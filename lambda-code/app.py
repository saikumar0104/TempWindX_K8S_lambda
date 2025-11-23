import os
import json
import logging
import psycopg2
from prometheus_client import CollectorRegistry, Gauge, push_to_gateway

# --- Logging ---
logging.basicConfig(level=logging.INFO)
log = logging.getLogger(__name__)

# --- Read config from environment variables ---
PG_HOST = os.environ.get("PG_HOST", "43.204.231.208")
PG_PORT = int(os.environ.get("PG_PORT", 5432))
PG_DB = os.environ.get("PG_DB", "testdb")
PG_USER = os.environ.get("PG_USER", "admin")
PG_PASS = os.environ.get("PG_PASS", "admin")

PUSHGATEWAY_URL = os.environ.get("PUSHGATEWAY_URL", "http://43.204.231.208:9091")
PUSHGATEWAY_JOB = os.environ.get("PUSHGATEWAY_JOB", "weather_metrics_lambda")

# Metric names (you said you renamed them earlier — use these or change)
METRIC_TEMP = "weather_temperature_lambda"
METRIC_WIND_SPEED = "weather_wind_speed_lambda"
METRIC_WIND_DIR = "weather_wind_direction_lambda"

def get_db_connection():
    return psycopg2.connect(
        host=PG_HOST,
        port=PG_PORT,
        dbname=PG_DB,
        user=PG_USER,
        password=PG_PASS
    )

def fetch_latest_weather_per_city():
    """
    Returns list of tuples: (city_name, temperature, wind_speed, wind_direction)
    Uses DISTINCT ON(city_name) to get latest row per city (Postgres).
    """
    sql = """
        SELECT DISTINCT ON (city_name)
            city_name, temperature, wind_speed, wind_direction, timestamp
        FROM weather
        ORDER BY city_name, timestamp DESC;
    """
    conn = None
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute(sql)
        rows = cur.fetchall()
        cur.close()
        return rows
    finally:
        if conn:
            conn.close()

def push_metrics(records):
    """
    Pushes all city metrics to Pushgateway in one registry push.
    """
    if not records:
        log.warning("No records to push.")
        return

    registry = CollectorRegistry()
    g_temp = Gauge(METRIC_TEMP, "Temperature in Celsius", ["city"], registry=registry)
    g_speed = Gauge(METRIC_WIND_SPEED, "Wind speed in m/s", ["city"], registry=registry)
    g_dir = Gauge(METRIC_WIND_DIR, "Wind direction in degrees", ["city"], registry=registry)

    pushed_cities = []
    for rec in records:
        # rec could be (city_name, temperature, wind_speed, wind_direction, timestamp)
        city = rec[0]
        temp = rec[1]
        wind_speed = rec[2]
        wind_dir = rec[3]
        # Set values (skip if None)
        if temp is not None:
            g_temp.labels(city=city).set(temp)
        if wind_speed is not None:
            g_speed.labels(city=city).set(wind_speed)
        if wind_dir is not None:
            g_dir.labels(city=city).set(wind_dir)
        pushed_cities.append(city)
        log.info("Prepared metrics for city=%s temp=%s wind_speed=%s wind_dir=%s", city, temp, wind_speed, wind_dir)

    # Ensure URL starts with http:// or https://
    if not (PUSHGATEWAY_URL.startswith("http://") or PUSHGATEWAY_URL.startswith("https://")):
        pgw = "http://" + PUSHGATEWAY_URL
    else:
        pgw = PUSHGATEWAY_URL

    push_to_gateway(pgw, job=PUSHGATEWAY_JOB, registry=registry)
    log.info("Pushed metrics for %d cities to %s (job=%s)", len(pushed_cities), pgw, PUSHGATEWAY_JOB)
    return pushed_cities

def lambda_handler(event, context):
    try:
        rows = fetch_latest_weather_per_city()
        pushed = push_metrics(rows)
        body = {
            "pushed_cities_count": len(pushed) if pushed else 0,
            "pushed_cities": pushed or []
        }
        return {"statusCode": 200, "body": json.dumps(body)}
    except Exception as e:
        log.exception("Error in lambda_handler")
        return {"statusCode": 500, "body": json.dumps(str(e))}

# Local test helper — safe to keep in Lambda
if __name__ == "__main__":
    # Simulate a local run and print result (useful for GCP testing)
    result = lambda_handler({}, None)
    print(result)

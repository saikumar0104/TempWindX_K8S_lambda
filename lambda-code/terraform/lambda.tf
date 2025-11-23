# -----------------------------
# IAM ROLE FOR LAMBDA
# -----------------------------
resource "aws_iam_role" "lambda_role" {
  name = "weather-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach AWS-managed basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


# -----------------------------
# LAMBDA LAYER (dependencies)
# -----------------------------
resource "aws_lambda_layer_version" "weather_layer" {
  filename   = "${path.module}/../layer.zip"
  layer_name = "weather-layer"

  compatible_runtimes       = ["python3.12"]
  compatible_architectures  = ["x86_64"]   # VERY IMPORTANT
}

# -----------------------------
# LAMBDA DEPLOYMENT
# -----------------------------
resource "aws_lambda_function" "weather_lambda" {
  function_name = "weather-metrics-lambda"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.12"
  handler       = "app.lambda_handler"
  architectures = ["x86_64"]  
# POINTS TO package.zip CREATED BY GITHUB ACTIONS
  filename         = "${path.module}/../package.zip"
  source_code_hash = filebase64sha256("${path.module}/../package.zip")

  timeout = 30
  memory_size = 256

layers = [
    aws_lambda_layer_version.weather_layer.arn
  ]

  # Environment variables → Your app.py uses these
  environment {
    variables = {
      PG_HOST          = var.pg_host
      PG_PORT          = var.pg_port
      PG_DB            = var.pg_db
      PG_USER          = var.pg_user
      PG_PASS          = var.pg_pass
      PUSHGATEWAY_URL  = var.pushgateway_url
      PUSHGATEWAY_JOB  = "weather_metrics_lambda"
    }
  }
}

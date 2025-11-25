# 🌦️ TempWindX - Weather Microservice

TempWindX is a weather microservice that fetches real-time weather data from [metio.com](https://metio.com) API, processes this data, and writes it to a PostgreSQL database.

Lambda then reads the stored weather data from the database, converts it into metrics, and pushes those metrics to a Prometheus Gateway for monitoring.  

Prometheus and Grafana are deployed on Kubernetes clusters to collect and visualize these metrics.

## 🚀 Architecture Overview
1️⃣ Microservices
MS-1 (Pull Service)
Runs on EKS.
Fetches weather data from meteoi.com API and inserts into PostgreSQL (AWS RDS).

MS-2 (Metrics Converter)
Runs as AWS Lambda triggered every 5 min using EventBridge.
Reads data from PostgreSQL → converts → pushes metrics to Prometheus Pushgateway.

Diagram:


## 📁 Project Structure
TempWindX
├── Dockerfile
├── pom.xml
├── README.md
├── src/

├── .github
│   └── workflows
│       ├── 1-ci-build.yml                 # Build Spring Boot + Docker
│       ├── 2-cd-eks.yml                   # Apply K8s manifests
│       ├── 3-terraform-infra.yml          # Provision VPC + RDS + EKS
|       ├── 4-destroy.yml                  # destroy the Infra
│       ├── 5-deploy-lambda.yml            # Deploy Lambda + Layer
│       └── 6-destroy-lambda.yml           # Destroy Lambda infra

├── Infra_provisioning
│   ├── main.tf                            # Calls all modules
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars
│   └── modules
│       ├── vpc
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       ├── rds
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       └── eks
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf

├── k8s
│   ├── namespace.yaml
│   ├── weather-app
│   │   ├── configmap.yaml
│   │   ├── secret.yaml
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   └── monitoring
│       ├── prometheus-config.yaml
│       ├── prometheus-deployment.yaml
│       ├── prometheus-service.yaml
│       ├── grafana-deployment.yaml
│       ├── grafana-service.yaml
│       ├── pushgateway-deployment.yaml
│       └── pushgateway-service.yaml

└── lambda-code
    ├── app.py
    ├── layer
    │   └── python
    ├── requirements.txt
    └── terraform
        ├── backend.tf
        ├── eventbridge.tf
        ├── lambda.tf
        ├── outputs.tf
        ├── provider.tf
        └── variables.tf


------------------------
### 🔹 Workflow Summary
------------------------

| Stage | Tool | Description |
|--------|------|-------------|
| **Source Control** | GitHub | Developer pushes code to repository |
| **CI Build** | GitHub Actions + Maven | Builds the project and packages it (JAR) |
| **Containerization** | Docker | Builds container image from JAR |
| **Security Scan** | Trivy | Scans Docker image for vulnerabilities |
| **Image Registry** | Docker Hub | Stores built image |
| **Infrastructure** | Terraform | Provisions AWS resources (VPC, EKS, S3, cloudwatch,lambda and lamda layer, Eventbridge scheduler) |
| **Deployment** | EKS | Runs the weather service container and all Monitoring tools|
| **Monitoring** | Prometheus + Grafana (on K8s) | lambda pushes metrics data to Prometheus GateWay |

---------------------
## ⚙️ CI/CD Pipeline
---------------------
### 🧱 Continuous Integration (`.github/workflows/maven-docker.yml`)
- Checkout source code  
- Setup Java  
- Build with Maven  
- Build Docker image  
- Run **Trivy security scan**  
- Push image to **Docker Hub**

### 2. Provisioning Infra (`.github/workflows/terraform-infra.yml`)
-Creates VPC, RDS, EKS

### 3. Deploy to EKS (`.github/workflows/cd-eks.yml`)
Applies manifests:
-Weather-app
-Pushgateway
-Prometheus
-Grafana


### 🧹 4 Destroy Infrastructure (`.github/workflows/destroy.yml`)
- Destroys the AWS infrastructure using Terraform

### 5. Deploy Lambda  (`.github/workflows/deploy-lambda.yml`)
- Creates Lambda, Eventbridge
- Installs Python dependencies
- Creates Lambda Layer
- Archives Lambda package
- Runs terraform apply

### 🧹 6. Destroy Lambda (`.github/workflows/destroy-lambda.yml`)
-Runs terraform destroy for Lambda stack only


------------------------------
🔐 Security & Best Practices 
------------------------------
Image scanning with Trivy
Infrastructure managed as code via Terraform
Secrets managed in GitHub Actions or AWS Secrets Manager
Immutable image-based deployments

To check whether data is pushed to pushgateway:
wget -qO- http://<Pushgateway>:9091/metrics | grep weather

Prometheus Scraping data:
<img width="1360" height="470" alt="image" src="https://github.com/user-attachments/assets/1d5212e3-3f30-470f-8621-3e1477f3601e" />

<img width="1356" height="478" alt="image" src="https://github.com/user-attachments/assets/33310a43-6f6f-4863-9a31-25b5ed4ca715" />

Visualize data from grafana:
<img width="800" height="396" alt="image" src="https://github.com/user-attachments/assets/c1c0d471-40c5-4720-86b7-2d101b4da87b" />

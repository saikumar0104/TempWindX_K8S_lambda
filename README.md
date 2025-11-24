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
│       ├── 5-deploy-lambda.yml            # Deploy Lambda + Layer
│       └── 6-destroy-lambda.yml           # Destroy Lambda infra

├── infra
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


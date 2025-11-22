TempWindX/
├── Dockerfile
├── pom.xml
├── README.md
├── src/

├── .github/
│   └── workflows/
│       ├── ci-build.yml            # Build & push Docker image to DockerHub
│       ├── cd-eks.yml              # Deploy to EKS (kubectl apply)
│       └── terraform-infra.yml     # Create VPC, RDS & EKS cluster

├── infra/
│   ├── main.tf                     # Calls all modules
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars
│   └── modules/
│       ├── vpc/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       ├── rds/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       └── eks/
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf

└── k8s/
    ├── namespace.yaml
    ├── weather-app/
    │   ├── configmap.yaml
    │   ├── secret.yaml
    │   ├── deployment.yaml
    │   └── service.yaml
    └── monitoring/
        ├── prometheus-config.yaml
        ├── prometheus-deployment.yaml
        ├── prometheus-service.yaml
        ├── grafana-deployment.yaml
        ├── grafana-service.yaml
        ├── pushgateway-deployment.yaml
        └── pushgateway-service.yaml


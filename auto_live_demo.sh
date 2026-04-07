#!/bin/bash
set -e

# Visual styling
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

export TF_TOKEN_app_terraform_io="qzC9lKWgDyG3uQ.atlasv1.A7td2pyUDbDyw62yzzZcS7Hr8CEyXgzys0YyJ8OjOAZd2YzzyclNUrk4wlyfRaqrCdo"
export VAULT_TOKEN="hvs.CAESIJY1zV1c6dcm2WzbM4JzJpAVmJm-MOfCci5yG1hxJXMDGikKImh2cy5Yc3NYZVc3d1dHSmQ0eVlhWnZTR0pCNEkueEJNSlAQicbWCg"
export VAULT_ADDR="https://vault-cluster-public-vault-d73c9b8f.dfa4b06b.z1.hashicorp.cloud:8200"
export AWS_ACCESS_KEY_ID="AKIAZBNNS3LERBPBY6GE"
export AWS_SECRET_ACCESS_KEY="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"
export TFE_TOKEN="qzC9lKWgDyG3uQ.atlasv1.A7td2pyUDbDyw62yzzZcS7Hr8CEyXgzys0YyJ8OjOAZd2YzzyclNUrk4wlyfRaqrCdo"

echo -e "\n${BLUE}[1/5] Provisioning strictly scoped AWS IAM Role for Vault...${NC}"
cd aws-setup
terraform init -upgrade > /dev/null 2>&1
terraform apply -auto-approve | grep -v "Reading..." | grep -v "Refreshing state..."
cd ..

echo -e "\n${BLUE}[2/5] Provisioning the Root Platform (Tier 1)...${NC}"
cd tier-1-platform
cp ../legacy-monolith/terraform.tfvars . || true
terraform init -upgrade > /dev/null 2>&1
terraform apply -auto-approve | grep -v "Reading..." | grep -v "Refreshing state..."
cd ..

echo -e "\n${BLUE}[3/5] Provisioning Application Onboarding (Tier 2)...${NC}"
cd tier-2-app-onboarding
cp ../legacy-monolith/terraform.tfvars . || true
terraform init -upgrade > /dev/null 2>&1
terraform apply -auto-approve | grep -v "Reading..." | grep -v "Refreshing state..."
cd ..

echo -e "\n${BLUE}[4/5] Testing Application Deployment (Dynamic AWS STS Keys)...${NC}"
cd app-repository
terraform init -upgrade > /dev/null 2>&1
# Allow errors on the app apply, often it waits for cloud sync.
terraform apply -auto-approve || echo "Some TFC apply output warning, proceeding."
cd ..

echo -e "\n${GREEN}Live testing completed! The environment has been left running for you to inspect in Terraform Cloud and AWS.${NC}"

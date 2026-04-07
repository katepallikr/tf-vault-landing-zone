#!/bin/bash

# Visual styling
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Hardcoded environment tokens for guaranteed demo execution
export TF_TOKEN_app_terraform_io="qzC9lKWgDyG3uQ.atlasv1.A7td2pyUDbDyw62yzzZcS7Hr8CEyXgzys0YyJ8OjOAZd2YzzyclNUrk4wlyfRaqrCdo"
export VAULT_TOKEN="hvs.CAESIJY1zV1c6dcm2WzbM4JzJpAVmJm-MOfCci5yG1hxJXMDGikKImh2cy5Yc3NYZVc3d1dHSmQ0eVlhWnZTR0pCNEkueEJNSlAQicbWCg"
export VAULT_ADDR="https://vault-cluster-public-vault-d73c9b8f.dfa4b06b.z1.hashicorp.cloud:8200"
export AWS_ACCESS_KEY_ID="AKIAZBNNS3LERBPBY6GE"
export AWS_SECRET_ACCESS_KEY="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"
export TFE_TOKEN="qzC9lKWgDyG3uQ.atlasv1.A7td2pyUDbDyw62yzzZcS7Hr8CEyXgzys0YyJ8OjOAZd2YzzyclNUrk4wlyfRaqrCdo"

clear

echo -e "${YELLOW}================================================================${NC}"
echo -e "${YELLOW}  Vault Dynamic Credentials & TFC Landing Zone - LIVE DEMO${NC}"
echo -e "${YELLOW}================================================================${NC}\n"

read -p "Press [Enter] to dynamically build the foundational AWS IAM Role..."

echo -e "\n${BLUE}[1/4] Provisioning strictly scoped AWS IAM Role for Vault...${NC}"
cd aws-setup || exit
terraform init -upgrade > /dev/null 2>&1
terraform apply -auto-approve | grep -v "Reading..." | grep -v "Refreshing state..."
cd ..

echo -e "\n"
read -p "Press [Enter] to deploy the TFC Root Orchestrator (OIDC & Workspaces)..."

echo -e "\n${BLUE}[2/4] Provisioning the Root Platform Landing Zone...${NC}"
echo -e "${GREEN} -> Creating TFC Projects & Workspaces${NC}"
echo -e "${GREEN} -> Injecting Vault Auth variables${NC}"
echo -e "${GREEN} -> Bootstrapping Vault JWT OIDC trust backend${NC}"
terraform init -upgrade > /dev/null 2>&1
terraform apply -auto-approve | grep -v "Reading..." | grep -v "Refreshing state..."
echo -e "\n${GREEN}Root Landing Zone deployed! Switch to your browser tabs now to show the Workspaces and Vault!${NC}"

echo -e "\n"
read -p "Press [Enter] to run the Application Deployment (STS Validation)..."

echo -e "\n${BLUE}[3/4] Testing Application Deployment (Dynamic AWS STS Keys)...${NC}"
echo -e "${GREEN} -> Submitting code to TFC...${NC}"
echo -e "${GREEN} -> TFC authenticates to Vault via natively injected OIDC tokens...${NC}"
echo -e "${GREEN} -> Vault locally assumes the AWS role via sts:AssumeRole...${NC}"
echo -e "${GREEN} -> Vault passes temporary STS tokens to TFC to build the S3 bucket...${NC}"
cd app-repository || exit
terraform init -upgrade > /dev/null 2>&1
terraform apply -auto-approve 
cd ..
echo -e "\n${GREEN}Application successfully deployed! Switch to your AWS Console to verify the S3 bucket exists.${NC}"

echo -e "\n"
read -p "Press [Enter] to completely teardown the infrastructure..."

echo -e "\n${BLUE}[4/4] Automated Tear Down Sequence...${NC}"
echo -e "${YELLOW} -> Destroying App Repository...${NC}"
cd app-repository || exit
terraform destroy -auto-approve > destroy.log 2>&1
cd ..
echo -e "${YELLOW} -> Destroying AWS internal IAM Roles...${NC}"
cd aws-setup || exit
terraform destroy -auto-approve > destroy.log 2>&1
cd ..
echo -e "${YELLOW} -> Destroying the Platforms Orchestrator (Workspaces & OIDC Hooks)...${NC}"
terraform destroy -auto-approve > destroy.log 2>&1

echo -e "\n${GREEN}Demo Complete! The environment has been returned to its original clean state.${NC}"
echo -e "${YELLOW}================================================================${NC}\n"

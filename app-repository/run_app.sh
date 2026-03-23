#!/bin/bash
export TF_TOKEN_app_terraform_io="GSbtyclMI6bPRg.atlasv1.T9JT1amV7NwIJgRKyz8neyiJMDebbts4Uqm0M8v4m94hxeNtmkocFHVND8tzdWvjijw"
# We also need to supply the variable file if it doesn't get uploaded automatically, but TFC Cloud executing uses the local tfvars.
terraform init > init.log 2>&1
terraform apply -auto-approve > apply.log 2>&1

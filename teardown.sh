#!/bin/bash
set -e

export TF_TOKEN_app_terraform_io="GSbtyclMI6bPRg.atlasv1.T9JT1amV7NwIJgRKyz8neyiJMDebbts4Uqm0M8v4m94hxeNtmkocFHVND8tzdWvjijw"
export VAULT_TOKEN="hvs.CAESIMq5Ue078M18iCmAGZ9ztViDtPhr2zLt-A06oAaXaTG_GikKImh2cy52c1VBNjEyYmlzTWJBb0VZdURKYlJvZ1YueEJNSlAQ0uzSCQ"
export AWS_ACCESS_KEY_ID="AKIA4EGCF2T6EZQ6QZQT"
export AWS_SECRET_ACCESS_KEY="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"

echo "=== Destroying App Repository ==="
cd /Users/kranthikatepalli/Downloads/golden-module/app-repository
terraform destroy -auto-approve > app_destroy.log 2>&1

echo "=== Destroying AWS Setup ==="
cd /Users/kranthikatepalli/Downloads/golden-module/aws-setup
terraform destroy -auto-approve > aws_destroy.log 2>&1

echo "=== Destroying Root Module ==="
cd /Users/kranthikatepalli/Downloads/golden-module
export TFE_TOKEN="GSbtyclMI6bPRg.atlasv1.T9JT1amV7NwIJgRKyz8neyiJMDebbts4Uqm0M8v4m94hxeNtmkocFHVND8tzdWvjijw"
terraform destroy -auto-approve > root_destroy.log 2>&1

echo "All destroyed!"

#!/bin/bash
export TFE_TOKEN="GSbtyclMI6bPRg.atlasv1.T9JT1amV7NwIJgRKyz8neyiJMDebbts4Uqm0M8v4m94hxeNtmkocFHVND8tzdWvjijw"
export VAULT_TOKEN="hvs.CAESIMq5Ue078M18iCmAGZ9ztViDtPhr2zLt-A06oAaXaTG_GikKImh2cy52c1VBNjEyYmlzTWJBb0VZdURKYlJvZ1YueEJNSlAQ0uzSCQ"
terraform apply -auto-approve > apply.log 2>&1

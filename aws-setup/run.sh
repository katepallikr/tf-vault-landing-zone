#!/bin/bash
export AWS_ACCESS_KEY_ID="AKIA4EGCF2T6EZQ6QZQT"
export AWS_SECRET_ACCESS_KEY="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"
terraform init > init.log 2>&1
terraform apply -auto-approve > apply.log 2>&1

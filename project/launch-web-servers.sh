#!/usr/bin/env bash
aws ec2 create-key-pair --key-name testdevops-KP --query 'KeyMaterial' --output text > testdevops-KP.pem
aws cloudformation create-stack --template-body=file://./web-servers-stack.yml --stack-name=web-servers-infra --capabilities CAPABILITY_NAMED_IAM
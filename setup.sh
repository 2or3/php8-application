#!/bin/bash

entry_point=`pwd`

cd terraform
eval "$(direnv export bash)";
terraform plan
terraform apply

cd $entry_point

/usr/local/bin/aws ecs register-task-definition --cli-input-json file://task_definition_pre.json --region ap-northeast-1
/usr/local/bin/aws ecs create-service --cli-input-json file://service.json --region=ap-northeast-1

cd terraform
eval "$(direnv export bash)";
terraform plan
terraform apply


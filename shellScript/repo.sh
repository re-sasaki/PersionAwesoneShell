#!/bin/bash
APP=(argos2 cicddeployapp cicddeploy cicddevapp cicddev daq ecr infra vms vpc)

for name in ${APP[@]}; do
echo ${name}
aws codecommit create-repository --repository-name gtc-${name}-master-jp-codecommit-cfn-cicd --repository-description "CodeCommit for ${name}. The environment is a master. Area is jp." --profile 20m
done

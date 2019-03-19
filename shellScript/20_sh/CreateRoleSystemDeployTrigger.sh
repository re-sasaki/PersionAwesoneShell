#!/bin/bash
conf=`cat ${1}`
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=

bash Confirm.sh || exit 1

echo "Create Trigger Role for CodeBuild..."
aws iam create-role \
--role-name codebuild-system-deploy-cicd-trigger \
--description "Allows CodeBuild and CodePipeline to call AWS services on your behalf." \
--assume-role-policy-document file://iam_json/CodeBuild-CodePipelinePolicy-assume-role.json \
--profile $PROFILE

aws iam put-role-policy \
--role-name codebuild-system-deploy-cicd-trigger \
--policy-name codebuild-system-deploy-cicd-trigger \
--policy-document file://iam_json/CodeBuild-System-Deploy-Trigger.json \
--profile $PROFILE
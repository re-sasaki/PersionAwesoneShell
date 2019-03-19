#!/bin/bash
conf=`cat ${1}`
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=

bash Confirm.sh || exit 1

echo "Create Role for CodeBuild..."
aws iam create-role \
--role-name codebuild-system-deploy-cicd \
--description "Allows CodeBuild to call AWS services on your behalf." \
--assume-role-policy-document file://iam_json/CodeBuildPolicy-assume-role.json \
--profile $PROFILE

aws iam attach-role-policy \
--role-name codebuild-system-deploy-cicd \
--policy-arn arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess \
--profile $PROFILE

aws iam attach-role-policy \
--role-name codebuild-system-deploy-cicd \
--policy-arn arn:aws:iam::aws:policy/AdministratorAccess \
--profile $PROFILE

aws iam put-role-policy \
--role-name codebuild-system-deploy-cicd \
--policy-name CodeBuildPolicy-system-deploy-cicd \
--policy-document file://iam_json/CodeBuildPolicy-system-deploy-cicd.json \
--profile $PROFILE

echo "Create Role for CodePipeline..."
aws iam create-role \
--role-name CodePipeline-system-deploy-cicd \
--description "Allows CodePipeline to call AWS services on your behalf." \
--assume-role-policy-document file://iam_json/CodePipelinePolicy-assume-role.json \
--profile $PROFILE

aws iam put-role-policy \
--role-name CodePipeline-system-deploy-cicd \
--policy-name CodePipelinePolicy-system-deploy-cicd \
--policy-document file://iam_json/CodePipelinePolicy-system-deploy-cicd.json \
--profile $PROFILE

echo "Create Role for CloudwatchEvents..."
aws iam create-role \
--role-name cwe-system-deploy-cicd \
--description "Allows CloudWatchEvents to call AWS services on your behalf." \
--assume-role-policy-document file://iam_json/CloudWatchEventsPolicy-assume-role.json \
--profile $PROFILE

aws iam put-role-policy \
--role-name cwe-system-deploy-cicd \
--policy-name start-pipeline-execution-system-deploy-cicd \
--policy-document file://iam_json/start-pipeline-execution-system-deploy-cicd.json \
--profile $PROFILE

echo "Create Role for CloudFormation..."
aws iam create-role \
--role-name cfn-system-deploy-cicd \
--description "Allows CloudFormation to create and manage AWS stacks and resources on your behalf." \
--assume-role-policy-document file://iam_json/CloudFormationPolicy-assume-role.json \
--profile $PROFILE

aws iam attach-role-policy \
--role-name cfn-system-deploy-cicd \
--policy-arn arn:aws:iam::aws:policy/AWSCodeCommitFullAccess \
--profile $PROFILE

aws iam attach-role-policy \
--role-name cfn-system-deploy-cicd \
--policy-arn arn:aws:iam::aws:policy/IAMFullAccess \
--profile $PROFILE

aws iam attach-role-policy \
--role-name cfn-system-deploy-cicd \
--policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess \
--profile $PROFILE

aws iam attach-role-policy \
--role-name cfn-system-deploy-cicd \
--policy-arn arn:aws:iam::aws:policy/AWSCodePipelineFullAccess \
--profile $PROFILE

aws iam attach-role-policy \
--role-name cfn-system-deploy-cicd \
--policy-arn arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess \
--profile $PROFILE

aws iam attach-role-policy \
--role-name cfn-system-deploy-cicd \
--policy-arn arn:aws:iam::aws:policy/CloudWatchEventsFullAccess \
--profile $PROFILE

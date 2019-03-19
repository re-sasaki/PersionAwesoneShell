#!/bin/bash
conf=`cat ${1}`
REGION=`echo $conf | jq -r '.Target[].Region'` && set | grep REGION=
AREA=`echo $conf | jq -r '.Target[].Area'` && set | grep AREA=
ENVIRONMENT=`echo $conf | jq -r '.Target[].Environment'` && set | grep ENVIRONMENT=
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=
ACCOUNT_ID=`echo $conf | jq -r '.Target[].AccountId'` && set | grep ACCOUNT_ID=

bash Confirm.sh || exit 1

echo "Create IbmAppParamPipeline..."

aws cloudformation create-stack \
--stack-name gtc-ibm-app-parameterstore-deploy-$ENVIRONMENT-$AREA \
--template-url https://s3.amazonaws.com/gtc-$ENVIRONMENT-$AREA-s3-cfn-cicd-infra/ibm-app-deploy-stack.yml \
--parameters \
ParameterKey=TemplateBucketName,ParameterValue=gtc-$ENVIRONMENT-$AREA-s3-cfn-cicd-infra \
ParameterKey=AreaCode,ParameterValue=$AREA \
ParameterKey=EnvCode,ParameterValue=$ENVIRONMENT \
ParameterKey=CodeBuildRole,ParameterValue=arn:aws:iam::$ACCOUNT_ID:role/codebuild-system-deploy-cicd \
ParameterKey=CodePipelineRole,ParameterValue=arn:aws:iam::$ACCOUNT_ID:role/CodePipeline-system-deploy-cicd \
ParameterKey=CloudWatchEventsRole,ParameterValue=arn:aws:iam::$ACCOUNT_ID:role/cwe-system-deploy-cicd \
--capabilities CAPABILITY_NAMED_IAM \
--role-arn arn:aws:iam::$ACCOUNT_ID:role/cfn-system-deploy-cicd \
--profile $PROFILE --region $REGION
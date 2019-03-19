#!/bin/bash
conf=`cat ${1}`
REGION=`echo $conf | jq -r '.Target[].Region'` && set | grep REGION=
AREA=`echo $conf | jq -r '.Target[].Area'` && set | grep AREA=
ENVIRONMENT=`echo $conf | jq -r '.Target[].Environment'` && set | grep ENVIRONMENT=
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=
ENVIRONMENT_DEV=`echo $conf | jq -r '.DEV_JAST[].Environment'` && set | grep ENVIRONMENT_DEV=

bash Confirm.sh || exit 1

echo "Update Redmine Template..."

echo "Copy to S3 Bucket"
aws s3 cp gtc-redmine-$ENVIRONMENT_DEV-$AREA-codecommit-cfn-cicd s3://gtc-redmine-$ENVIRONMENT-$AREA-s3-cfn-cicd \
--recursive --exclude ".git/*" \
--profile $PROFILE --region $REGION

echo "Create Redmine main..."

aws cloudformation create-stack \
--template-url https://s3-ap-northeast-1.amazonaws.com/gtc-redmine-$ENVIRONMENT-$AREA-s3-cfn-cicd/gtc-redmine-main-stack.yml \
--stack-name gtc-redmine-$ENVIRONMENT-$AREA-main-stack \
--capabilities CAPABILITY_NAMED_IAM \
--profile $PROFILE --region $REGION
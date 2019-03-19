#!/bin/bash
conf=`cat ${1}`
REGION=`echo $conf | jq -r '.Target[].Region'` && set | grep REGION=
AREA=`echo $conf | jq -r '.Target[].Area'` && set | grep AREA=
ENVIRONMENT=`echo $conf | jq -r '.Target[].Environment'` && set | grep ENVIRONMENT=
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=
PROFILEDEV=`echo $conf | jq -r '.DEV_JAST[].Profile'` && set | grep PROFILEDEV=
PROFILEIBM=`echo $conf | jq -r '.IBM[].Profile'` && set | grep PROFILEIBM=
ENVIBM=`echo $conf | jq -r '.IBM[].Environment'` && set | grep ENVIBM=
PROFILESSS=`echo $conf | jq -r '.SSS[].Profile'` && set | grep PROFILESSS=
ENVSSS=`echo $conf | jq -r '.SSS[].Environment'` && set | grep ENVSSS=

bash Confirm.sh || exit 1

##pipeline-create Clone
echo "Clone the infra-popeline-create ConfigFile ..."
aws s3 cp s3://gtc-infra-pipeline-create-qj-us-s3-deploy-settings/cfn-parameters \
gtc-infra-pipeline-create-qj-us-s3-deploy-settings/cfn-parameters \
--recursive --profile $PROFILEDEV
echo "Clone the ibm-app-popeline-create ConfigFile ..."
aws s3 cp s3://gtc-ibm-app-pipeline-create-qj-us-s3-deploy-settings/cfn-parameters \
gtc-ibm-app-pipeline-create-qj-us-s3-deploy-settings/cfn-parameters \
--recursive --profile $PROFILEDEV
echo "Clone the sss-app-popeline-create ConfigFile ..."
aws s3 cp s3://gtc-sss-app-pipeline-create-qj-us-s3-deploy-settings/cfn-parameters \
gtc-sss-app-pipeline-create-qj-us-s3-deploy-settings/cfn-parameters \
--recursive --profile $PROFILEDEV
##param Clone
echo "Clone the infra ConfigFile ..."
aws s3 cp s3://gtc-infra-qj-us-s3-deploy-settings/cfn-parameters \
gtc-infra-qj-us-s3-deploy-settings/cfn-parameters \
--recursive --profile $PROFILEDEV
echo "Clone the ibm-app-param ConfigFile ..."
aws s3 cp s3://gtc-ibm-app-$ENVIBM-$AREA-s3-settings/cfn-parameters \
gtc-ibm-app-$ENVIBM-$AREA-s3-deploy-settings/cfn-parameters \
--recursive --profile $PROFILEIBM
echo "Clone the sss-app-param ConfigFile ..."
aws s3 cp s3://gtc-sss-app-$ENVSSS-$AREA-s3-settings/cfn-parameters \
gtc-sss-app-$ENVSSS-$AREA-s3-deploy-settings/cfn-parameters \
--recursive --profile $PROFILESSS

##pipeline-create Put
echo "Put to s3://gtc-infra-pipeline-create-$ENVIRONMENT-$AREA-s3-deploy-settings/cfn-parameters/..."
aws s3 cp gtc-infra-pipeline-create-qj-us-s3-deploy-settings/cfn-parameters/ \
s3://gtc-infra-pipeline-create-$ENVIRONMENT-$AREA-s3-deploy-settings/cfn-parameters/ \
--recursive --profile $PROFILE --region $REGION
echo "Put to s3://gtc-ibm-app-pipeline-create-$ENVIRONMENT-$AREA-s3-deploy-settings/cfn-parameters/..."
aws s3 cp gtc-ibm-app-pipeline-create-qj-us-s3-deploy-settings/cfn-parameters/ \
s3://gtc-ibm-app-pipeline-create-$ENVIRONMENT-$AREA-s3-deploy-settings/cfn-parameters/ \
--recursive --profile $PROFILE --region $REGION
echo "Put to s3://gtc-sss-app-pipeline-create-$ENVIRONMENT-$AREA-s3-deploy-settings/cfn-parameters/..."
aws s3 cp gtc-sss-app-pipeline-create-qj-us-s3-deploy-settings/cfn-parameters/ \
s3://gtc-sss-app-pipeline-create-$ENVIRONMENT-$AREA-s3-deploy-settings/cfn-parameters/ \
--recursive --profile $PROFILE --region $REGION
##param Put
echo "Put to s3://gtc-infra-$ENVIRONMENT-$AREA-s3-deploy-settings/cfn-parameters/..."
aws s3 cp gtc-infra-qj-us-s3-deploy-settings/cfn-parameters/ \
s3://gtc-infra-$ENVIRONMENT-$AREA-s3-deploy-settings/cfn-parameters/ \
--recursive --profile $PROFILE --region $REGION
echo "Put to s3://gtc-ibm-app-$ENVIRONMENT-$AREA-s3-deploy-settings/cfn-parameters/..."
aws s3 cp gtc-ibm-app-$ENVIBM-$AREA-s3-deploy-settings/cfn-parameters/ \
s3://gtc-ibm-app-$ENVIRONMENT-$AREA-s3-deploy-settings/cfn-parameters/ \
--recursive --profile $PROFILE --region $REGION
echo "Put to s3://gtc-sss-app-$ENVIRONMENT-$AREA-s3-deploy-settings/cfn-parameters/..."
aws s3 cp gtc-sss-app-$ENVSSS-$AREA-s3-deploy-settings/cfn-parameters/ \
s3://gtc-sss-app-$ENVIRONMENT-$AREA-s3-deploy-settings/cfn-parameters/ \
--recursive --profile $PROFILE --region $REGION

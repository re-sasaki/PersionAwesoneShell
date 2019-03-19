#!/bin/bash
conf=`cat ${1}`
REGION=`echo $conf | jq -r '.Target[].Region'` && set | grep REGION=
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=
ACCOUNT_ID=`echo $conf | jq -r '.Target[].AccountId'` && set | grep ACCOUNT_ID=

bash Confirm.sh || exit 1

RoleName="20MGTC-ConfigRole"
ConfigurationRecorderName="default"

echo "Check Role existense..."
RoleList=$(aws iam list-roles --profile $PROFILE | jq -r ".Roles[].RoleName")
if [ `echo "$RoleList" | grep $RoleName` ]; then
  :
else
  echo "Create IAM Role..."
  aws iam create-role \
  --role-name $RoleName \
  --path "/service-role/"
  --assume-role-policy-document file://iam_json/ConfigServicePolicy.json \
  --profile $PROFILE

  aws iam attach-role-policy \
  --role-name $RoleName \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSConfigRole \
  --profile $PROFILE
fi

echo "Check Bucket existense..."
BucketList=$(aws s3api list-buckets --profile $PROFILE | jq -r ".Buckets[].Name")
if [ `echo "$BucketList" | grep 20mgtc-jst-aws-configlogs` ]; then
  :
else
  echo "Create S3 Bucket..."
  aws s3 mb s3://20mgtc-jst-aws-configlogs \
  --profile $PROFILE --region $REGION
  
  echo "Setup Bucket Encryption..."
  # Create Json
  cat << EOS > S3SSE.json 
  {
    "Rules": [
      {
        "ApplyServerSideEncryptionByDefault": {
          "SSEAlgorithm": "AES256"
        }
      }
    ]
  }
EOS

  aws s3api put-bucket-encryption --bucket 20mgtc-jst-aws-configlogs \
  --server-side-encryption-configuration file://S3SSE.json \
  --profile $PROFILE --region $REGION

  rm S3SSE.json
fi

# Create Json
cat << EOS > deliveryChannel.json 
{
  "name": "$ConfigurationRecorderName",
  "s3BucketName": "20mgtc-jst-aws-configlogs"
}
EOS

echo "Put Delivery Channel..."
aws configservice put-delivery-channel --delivery-channel file://deliveryChannel.json \
--profile $PROFILE --region $REGION

echo "Start Configuration Recorder..."
aws configservice start-configuration-recorder --configuration-recorder-name $ConfigurationRecorderName \
--profile $PROFILE --region $REGION

echo "Put Configuration Recorder..."
aws configservice put-configuration-recorder \
--configuration-recorder name=$ConfigurationRecorderName,roleARN=arn:aws:iam::$ACCOUNT_ID:role/service-role/$RoleName \
--recording-group allSupported=true,includeGlobalResourceTypes=true \
--profile $PROFILE --region $REGION

rm deliveryChannel.json

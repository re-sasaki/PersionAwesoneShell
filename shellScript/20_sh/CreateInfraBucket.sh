#!/bin/bash
conf=`cat ${1}`
REGION=`echo $conf | jq -r '.Target[].Region'` && set | grep REGION=
AREA=`echo $conf | jq -r '.Target[].Area'` && set | grep AREA=
ENVIRONMENT=`echo $conf | jq -r '.Target[].Environment'` && set | grep ENVIRONMENT=
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=

bash Confirm.sh || exit 1

echo "Make S3 Bucket..."
aws s3 mb s3://gtc-$ENVIRONMENT-$AREA-s3-cfn-cicd-infra \
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

aws s3api put-bucket-encryption --bucket gtc-$ENVIRONMENT-$AREA-s3-cfn-cicd-infra \
--server-side-encryption-configuration file://S3SSE.json \
--profile $PROFILE --region $REGION

rm S3SSE.json
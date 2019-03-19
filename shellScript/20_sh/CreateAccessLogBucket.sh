#!/bin/bash
conf=`cat ${1}`
REGION=`echo $conf | jq -r '.Target[].Region'` && set | grep REGION=
AREA=`echo $conf | jq -r '.Target[].Area'` && set | grep AREA=
ENVIRONMENT=`echo $conf | jq -r '.Target[].Environment'` && set | grep ENVIRONMENT=
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=


bash Confirm.sh || exit 1

BucketName="20mgtc-$ENVIRONMENT-$AREA-s3-accesslogs"

echo "Create S3 Bucket for AccessLogs"
aws s3api create-bucket --bucket $BucketName --profile $PROFILE \
--create-bucket-configuration LocationConstraint=$REGION \
--grant-write 'uri="http://acs.amazonaws.com/groups/s3/LogDelivery"' \
--grant-read-acp 'uri="http://acs.amazonaws.com/groups/s3/LogDelivery"'

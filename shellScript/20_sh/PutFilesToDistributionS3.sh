#!/bin/bash
conf=`cat ${1}`
REGION=`echo $conf | jq -r '.Target[].Region'` && set | grep REGION=
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=

bash Confirm.sh || exit 1

echo "Put put.json&dummytrigger.zip..."

bucket=$(aws s3api list-buckets --profile $PROFILE --region $REGION \
| jq -r '.Buckets[] | select(.Name | test("distribution-settings")) | .Name')

aws s3 cp Put/ s3://$bucket/ --recursive --profile $PROFILE --region $REGION
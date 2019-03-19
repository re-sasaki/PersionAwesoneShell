#!/bin/bash
conf=`cat ${1}`
REGION=`echo $conf | jq -r '.Target[].Region'` && set | grep REGION=
AREA=`echo $conf | jq -r '.Target[].Area'` && set | grep AREA=
ENVIRONMENT=`echo $conf | jq -r '.Target[].Environment'` && set | grep ENVIRONMENT=
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=
ACCOUNT_ID=`echo $conf | jq -r '.Target[].AccountId'` && set | grep ACCOUNT_ID=

bash Confirm.sh || exit 1

#LocalParameters
BucketName=20mgtc-$ENVIRONMENT-$AREA-cloudtrail-test
TrailName=20MGTC-$ENVIRONMENT-$AREA-CloudTrail-Test

echo "Create Bucket $BucketName ..."
aws s3api create-bucket --bucket $BucketName --profile $PROFILE \
--create-bucket-configuration LocationConstraint=$REGION \

echo "Create BucketLoggingStatus.json ..."
cat << EOS > BucketLoggingStatus.json
{
  "LoggingEnabled": {
    "TargetBucket": "20mgtc-$ENVIRONMENT-$AREA-s3-accesslogs",
    "TargetPrefix": "$BucketName/"
  }
}
EOS

echo "Update Bucket LoggingStatus for $BucketName ..."
aws s3api put-bucket-logging \
--bucket $BucketName --profile $PROFILE \
--bucket-logging-status file://BucketLoggingStatus.json

echo "CloudTrailBucketPolicy.json ..."
cat << EOS > CloudTrailBucketPolicy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::$BucketName"
        },
        {
            "Sid": "AWSCloudTrailWrite20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::$BucketName/AWSLogs/$ACCOUNT_ID/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
EOS

echo "Update Bucket Policy for $BucketName ..."
aws s3api put-bucket-policy --bucket $BucketName \
--policy file://CloudTrailBucketPolicy.json \
--profile $PROFILE

echo "Create CloudTrail for $TrailName ..."
aws cloudtrail create-subscription --name=$TrailName \
--s3-use-bucket=$BucketName --region=$REGION --profile $PROFILE

echo "Update CloudTrail for $TrailName ..."
aws cloudtrail update-trail --name $TrailName \
--is-multi-region-trail --enable-log-file-validation \
--region=$REGION --profile $PROFILE

#!/bin/bash
conf=`cat ${1}`
REGION=`echo $conf | jq -r '.Target[].Region'` && set | grep REGION=
AREA=`echo $conf | jq -r '.Target[].Area'` && set | grep AREA=
ENVIRONMENT=`echo $conf | jq -r '.Target[].Environment'` && set | grep ENVIRONMENT=
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=
PROFILE_DEV=`echo $conf | jq -r '.DEV_JAST[].Profile'` && set | grep PROFILE_DEV=

bash Confirm.sh || exit 1

echo "Clone Redmine Repository..."

response=$(aws codecommit get-repository \
--repository-name gtc-redmine-dj-jp-codecommit-cfn-cicd \
--profile $PROFILE_DEV --region ap-northeast-1)

repoUrl=`echo $response | jq -r '.repositoryMetadata.cloneUrlHttp'`
repoName=`echo $response | jq -r '.repositoryMetadata.repositoryName'`

cp ~/.gitconfig ~/.gitconfig.org

git config --global credential.helper "!aws codecommit credential-helper --profile $PROFILE_DEV"
git config --global credential.UseHttpPath true

git clone $repoUrl

cp ~/.gitconfig.org ~/.gitconfig
rm ~/.gitconfig.org

echo "Make S3 Bucket..."
aws s3 mb s3://gtc-redmine-$ENVIRONMENT-$AREA-s3-cfn-cicd \
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

aws s3api put-bucket-encryption --bucket gtc-redmine-$ENVIRONMENT-$AREA-s3-cfn-cicd \
--server-side-encryption-configuration file://S3SSE.json \
--profile $PROFILE --region $REGION

rm S3SSE.json

echo "Copy to S3 Bucket"
aws s3 cp $repoName s3://gtc-redmine-$ENVIRONMENT-$AREA-s3-cfn-cicd \
--recursive --exclude ".git/*" \
--profile $PROFILE --region $REGION
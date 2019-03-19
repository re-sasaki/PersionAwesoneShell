#!/bin/bash
conf=`cat ${1}`
REGION=`echo $conf | jq -r '.Target[].Region'` && set | grep REGION=
AREA=`echo $conf | jq -r '.Target[].Area'` && set | grep AREA=
ENVIRONMENT=`echo $conf | jq -r '.Target[].Environment'` && set | grep ENVIRONMENT=
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=
PROFILE_DEV=`echo $conf | jq -r '.DEV_JAST[].Profile'` && set | grep PROFILE_DEV=

bash Confirm.sh || exit 1

echo "Clone Infra Repository..."

response=$(aws codecommit get-repository \
--repository-name gtc-infra-master-jp-codecommit-cfn-cicd \
--profile $PROFILE_DEV --region ap-northeast-1)

repoUrl=`echo $response | jq -r '.repositoryMetadata.cloneUrlHttp'`
repoName=`echo $response | jq -r '.repositoryMetadata.repositoryName'`

cp ~/.gitconfig ~/.gitconfig.org

git config --global credential.helper "!aws codecommit credential-helper --profile $PROFILE_DEV"
git config --global credential.UseHttpPath true

git clone $repoUrl

cp ~/.gitconfig.org ~/.gitconfig
rm ~/.gitconfig.org

echo "Copy to S3 Bucket"
aws s3 cp $repoName/codecommit_pipeline s3://gtc-$ENVIRONMENT-$AREA-s3-cfn-cicd-infra \
--recursive --exclude ".git/*" \
--profile $PROFILE --region $REGION

aws s3 cp $repoName/put_pipeline s3://gtc-$ENVIRONMENT-$AREA-s3-cfn-cicd-infra \
--recursive --exclude ".git/*" \
--profile $PROFILE --region $REGION

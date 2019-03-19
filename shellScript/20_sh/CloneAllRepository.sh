#!/bin/bash

echo "Clone Master Repositories..."

REPOSITORIES=(gtc-vpc-dj-jp-codecommit-cfn-cicd gtc-vms-dj-jp-codecommit-cfn-cicd gtc-agwdomain-dj-jp-codecommit-cfn-cicd gtc-daq-dj-jp-codecommit-cfn-cicd gtc-argos2-dj-jp-codecommit-cfn-cicd gtc-ecr-dj-jp-codecommit-cfn-cicd gtc-cicddev-dj-jp-codecommit-cfn-cicd)

git config --global credential.helper "!aws codecommit credential-helper --profile 20jast"
git config --global credential.UseHttpPath true

for repo in ${REPOSITORIES[@]}; do
  
  response=$(aws codecommit get-repository \
  --repository-name $repo \
  --profile 20jast --region ap-northeast-1)

  repoUrl=`echo $response | jq -r '.repositoryMetadata.cloneUrlHttp'`
  repoName=`echo $response | jq -r '.repositoryMetadata.repositoryName'`

  cp ~/.gitconfig ~/.gitconfig.org


  git clone $repoUrl

done 

cp ~/.gitconfig.org ~/.gitconfig
rm ~/.gitconfig.org

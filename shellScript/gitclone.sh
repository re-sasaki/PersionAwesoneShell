#!/bin/bash
# shだとエラー出るのでbashで実行されたし

if [ $# -ne 1 ];then
    profile='default'
    echo 'profile is' $profile
else
    profile=$1
    echo 'profile is' $profile
fi

git config --global credential.helper "!aws codecommit credential-helper \$@ --profile $profile"
git config --global credential.UseHttpPath true

#repolist=$(aws codecommit list-repositories --profile $profile | jq -r '.repositories[].repositoryName')
repolist=$(aws codecommit list-repositories --profile $profile | jq -r '.repositories[] | select(.repositoryName |test("master")) | .repositoryName')

for name in ${repolist[@]}; do
echo ${name}
git clone https://git-codecommit.ap-northeast-1.amazonaws.com/v1/repos/${name}
done

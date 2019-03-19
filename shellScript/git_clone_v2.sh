#!/bin/bash
echo "Profileを入力してね(入力しないとdefaultだよ):"
read PROFILE
if [ $PROFILE = "" ]; then
  PROFILE="default"
fi

echo "Region番号を入力してね(1.ap-northeast-1, 2.us-east-1):"
read REGION
case $REGION in
  1 ) REGION=ap-northeast-1 ;;
  2 ) REGION=us-east-1 ;;
esac

bash ~/shellscript/git_conf_change.sh $PROFILE

repolist=$(aws codecommit list-repositories --profile $PROFILE --region $REGION | jq -r '.repositories[].repositoryName')

for name in ${repolist[@]}; do
  echo ${name}
  git clone https://git-codecommit.ap-northeast-1.amazonaws.com/v1/repos/${name}
done

bash ~/shellscript/git_conf_reset.sh

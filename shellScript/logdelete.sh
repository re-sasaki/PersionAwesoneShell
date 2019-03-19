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

echo "消したいロググループに含まれる文字列を入力してね:"
read NAME

command="aws logs describe-log-groups --profile $PROFILE --region $REGION"
list=`$command | jq -r ".logGroups | map(select(.logGroupName|test(\"$NAME\")))| .[].logGroupName"`

if [ -z "$list" ]; then
  echo "該当するログがないよ"
  exit 1
fi

echo "削除モードを選んでね(1.選択削除, 2.一括削除):"
read MODE

echo "*ロググループ一覧*"
for file in ${list}; do 
    echo ${file}
done

case $MODE in
  1 )
  for file in ${list}; do 
    echo ""${file}"を削除するよ [Y/n]:"
    read isDelete
    if [ $isDelete = "Y" ];then
      aws logs delete-log-group --log-group-name ${file} --profile $PROFILE --region $REGION
    else
      echo ${file}"を削除しなかったよ"
    fi
  done
  ;;

  2 )
  echo "これらのロググループを削除するよ [Y/n]:"
  read isDelete
  if [ $isDelete = "Y" ];then
    for file in ${list}; do 
       aws logs delete-log-group --log-group-name ${file} --profile $PROFILE --region $REGION
       echo ${file}"を削除したよ"
    done
  else
    echo "削除をやめたよ"
  fi
  ;;
esac

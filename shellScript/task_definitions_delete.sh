#!/bin/bash

echo "Profileを入力してね(入力しないとdefaultだよ):"
read PROFILE
if [ $PROFILE = "" ]; then
  PROFILE="default"
fi

echo "INACTIVEにしたいタスク定義に含まれる文字列を入力してね:"
read NAME

list=$(aws ecs list-task-definitions --sort ASC --profile $PROFILE \
| jq -r ".taskDefinitionArns | map(select(.|test(\"$NAME\")))| .[]" \
| sed -e 's|.*/||g')


for l in ${list[@]}; do
  aws ecs deregister-task-definition --task-definition $l --profile $PROFILE > /dev/null
  echo "$lをINACTIVEにしたよ"
done

# command="aws logs describe-log-groups --profile $PROFILE --region $REGION"
# list=`$command | jq -r ".logGroups | map(select(.logGroupName|test(\"$NAME\")))| .[].logGroupName"`
# 
# if [ -z "$list" ]; then
#   echo "該当するログがないよ"
#   exit 1
# fi
# 
# echo "削除モードを選んでね(1.選択削除, 2.一括削除):"
# read MODE
# 
# echo "*ロググループ一覧*"
# for file in ${list}; do 
#     echo ${file}
# done
# 
# case $MODE in
#   1 )
#   for file in ${list}; do 
#     echo ""${file}"を削除するよ [Y/n]:"
#     read isDelete
#     if [ $isDelete = "Y" ];then
#       aws logs delete-log-group --log-group-name ${file} --profile $PROFILE --region $REGION
#     else
#       echo ${file}"を削除しなかったよ"
#     fi
#   done
#   ;;
# 
#   2 )
#   echo "これらのロググループを削除するよ [Y/n]:"
#   read isDelete
#   if [ $isDelete = "Y" ];then
#     for file in ${list}; do 
#        aws logs delete-log-group --log-group-name ${file} --profile $PROFILE --region $REGION
#        echo ${file}"を削除したよ"
#     done
#   else
#     echo "削除をやめたよ"
#   fi
#   ;;
# esac

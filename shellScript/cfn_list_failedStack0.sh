#!/bin/bash

# echo "Profileを入力してね(入力しないとdefaultだよ:"
# read PROFILE
# if [ $PROFILE = "" ]; then
#   PROFILE="default"
# fi
# 
# echo "Region番号を入力してね(1.ap-northeast-1, 2.us-east-1):"
# read REGION
# case $REGION in
#   1 ) REGION=ap-northeast-1 ;;
#   2 ) REGION=us-east-1 ;;
# esac

echo "Search Failed Stacks...."
REGION=ap-northeast-1
pList=(20m 20ibm 20sss 20q1jp)

for p in ${pList[@]}; do
  echo $p
  list=\
  $(aws cloudformation list-stacks \
  --stack-status-filter "CREATE_FAILED" "ROLLBACK_IN_PROGRESS" "ROLLBACK_FAILED" "ROLLBACK_COMPLETE" \
  "DELETE_FAILED" "UPDATE_ROLLBACK_IN_PROGRESS" "UPDATE_ROLLBACK_FAILED" "UPDATE_ROLLBACK_COMPLETE" \
  --region $REGION --profile $p)
  
  array=$(echo $list | jq '.StackSummaries[] | select((.RootId) | not)')
  echo $array |jq '{StackName: .StackName, StackStatus: .StackStatus}'
  
  echo "NOW"
  list=\
  $(aws cloudformation list-stacks \
  --stack-status-filter "CREATE_IN_PROGRESS" "UPDATE_IN_PROGRESS" "UPDATE_COMPLETE_CLEANUP_IN_PROGRESS" "DELETE_IN_PROGRESS" \
  --region $REGION --profile $p)
  
  array=$(echo $list | jq '.StackSummaries[] | select((.RootId) | not)')
  echo $array |jq '{StackName: .StackName, StackStatus: .StackStatus}'
  
done

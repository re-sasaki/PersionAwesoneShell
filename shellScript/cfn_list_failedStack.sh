#!/bin/bash

pList=(20jast 20ibm 20sss 20m 20q1jp 20q1us 20q1eu 20q1th 20q1id)
# pList=(djjp qjus dijp dsjp d1jp q1jp q1us q1eu q1th q1id)

failedstackfind=0

for p in ${pList[@]}; do
  list=$(aws cloudformation list-stacks \
  --stack-status-filter \
  "CREATE_FAILED" "DELETE_FAILED" "ROLLBACK_FAILED" "UPDATE_ROLLBACK_FAILED" \
  "ROLLBACK_IN_PROGRESS" "UPDATE_ROLLBACK_IN_PROGRESS" \
  "ROLLBACK_COMPLETE" "UPDATE_ROLLBACK_COMPLETE" \
  --profile $p)

  array=$(echo $list | jq '.StackSummaries[] | select((.RootId) | not)')
  if [ -n "$array" ]; then
    if [ $failedstackfind -eq 0 ]; then
      date
      echo "Search Failed Stacks..."
      failedstackfind=1
    fi
    echo ■■■$p■■■
    echo $array |jq '{StackName: .StackName, StackStatus: .StackStatus}'
  fi  
done



if [ $failedstackfind -ne 0 ]; then
  echo "■■■Environment List■■■"
  for p in ${pList[@]}; do
    echo -n ["$p"]
    echo -n AccountID:`aws sts get-caller-identity --profile $p | jq -r ".Account"`
    re=$(aws configure list --profile $p | grep region)
    re=(`echo $re|xargs`)
    echo , Region:${re[1]}
  done
  rm failedstackfind
fi


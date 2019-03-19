#!/bin/bash

pList=(20jast)
# pList=(djjp qjus dijp dsjp d1jp q1jp q1us q1eu q1th q1id)

failedstackfind=0

date
echo "Search Failed Stacks..."
for i in {0..100}; do
for p in ${pList[@]}; do
  list=$(aws cloudformation list-stacks \
  --stack-status-filter \
  "CREATE_FAILED" "DELETE_FAILED" "ROLLBACK_FAILED" "UPDATE_ROLLBACK_FAILED" \
  "ROLLBACK_IN_PROGRESS" "UPDATE_ROLLBACK_IN_PROGRESS" \
  "ROLLBACK_COMPLETE" "UPDATE_ROLLBACK_COMPLETE" \
  --profile $p)

  array=$(echo $list | jq '.StackSummaries[] | select((.RootId) | not)')
  if [ -n "$array" ]; then
    echo ■■■$p■■■
    echo $array |jq '{StackName: .StackName, StackStatus: .StackStatus}'
  fi  
done
done
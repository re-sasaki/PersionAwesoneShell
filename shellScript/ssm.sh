#!/bin/bash
name=$(aws ssm describe-parameters --profile 20m | jq -r '.Parameters[].Name')
count=0

for n in ${name}
do
list="${list} ${n}"
count=`echo "$count+1" | bc`
if [ $count -eq 10 ]; then
aws ssm get-parameters --names ${list} --profile 20m | jq -r '.Parameters[]'
count=0
list=''
fi
done


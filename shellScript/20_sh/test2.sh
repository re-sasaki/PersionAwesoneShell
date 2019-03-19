#!/bin/bash
conf=`cat ${1}`
REGION=`echo $conf | jq -r '.Target[].Region'` && set | grep REGION=
AREA=`echo $conf | jq -r '.Target[].Area'` && set | grep AREA=
ENVIRONMENT=`echo $conf | jq -r '.Target[].Environment'` && set | grep ENVIRONMENT=
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=
PROFILE_DEV=`echo $conf | jq -r '.DEV_JAST[].Profile'` && set | grep PROFILE_DEV=

list=$(aws ssm describe-parameters --profile 20jast | jq -r ".Parameters[].Name")

for l in ${list[@]}; do

param=$(aws ssm get-parameter --name $l --with-decryption --profile 20jast)

# name=`echo $param | jq -r ".Parameter.Name"`
# value=`echo $param | jq -r ".Parameter.Value"`
# 
# echo $name, $value >> list.txt

# echo $param | jq -r ". | map({Name: .Parameter.Name, Value: .Parameter.Value})"
echo $param | jq -r ".Parameter | {name: .Name, value: .Value}"
done

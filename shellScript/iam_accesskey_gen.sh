#!/bin/bash

echo "ユーザー番号を入力(ex. js03)"
read USER_NAME

# pList=(djjp qjus dijp dsjp d1jp q1jp q1us q1eu q1th q1id)
#pList=(20jast 20ibm 20sss 20m 20q1jp 20q1us 20q1eu 20q1th 20q1id)
pList=(20s1jp 20s1us 20s1eu 20s1th 20s1id)

function user_gen() {
  aws iam create-user --user-name $USER_NAME --profile $1
  
  while : ; do
    aws iam get-user --user-name $USER_NAME --profile $1 > /dev/null
    if [ $? -lt 1 ]; then
      break
    fi 
  done
  
  aws iam attach-user-policy --user-name $USER_NAME \
  --policy-arn arn:aws:iam::aws:policy/IAMReadOnlyAccess --profile $1
  
  aws iam attach-user-policy --user-name $USER_NAME \
  --policy-arn arn:aws:iam::aws:policy/AWSCloudFormationReadOnlyAccess --profile $1
}

function accesskey_gen() {
  echo "generateAccessKey..."
  res=$(aws iam create-access-key --user-name $2 --profile $1)
  
  accessKey=`echo $res | jq -r ".AccessKey.AccessKeyId"`
  secAccessKey=`echo $res | jq -r ".AccessKey.SecretAccessKey"`
  
  echo "[$1]" >> credentials
  echo "aws_access_key_id = $accessKey" >> credentials
  echo "aws_secret_access_key = $secAccessKey" >> credentials
}

function list_accessKey() {
  echo "listAccessKey..."
  accessKeyList=$(aws iam list-access-keys --user-name $2 --profile $1 | jq -r ".AccessKeyMetadata[].AccessKeyId")
}

function delete_accessKey() {
  echo "deleteAccessKey..."
  for l in ${accessKeyList[@]}; do
    aws iam delete-access-key --access-key-id $l --profile $1
  done 
}

function list_user() {
  echo "listUser..."
  userName=$(aws iam list-users --profile $1 | jq -r ".Users[] | select(.UserName | test(\"$USER_NAME\")) | .UserName")
}

touch credentials

for p in ${pList[@]}; do
  echo "$p"
  list_user $p
  #user_gen $p
  list_accessKey $p $userName
  accesskey_gen $p $userName
  #delete_accessKey $p
done

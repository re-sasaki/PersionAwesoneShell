#!/bin/bash

# echo -n "AWS Profile名を入力してください: " && read PROFILE
# echo -n "環境名(ENVIRONMENT)を入力してください[dev/ver/prd]: " && read ENVIRONMENT
# echo -n "地域(AREA)を入力してください[jp]: " && read AREA

PROFILE=${1}
ENVIRONMENT=${2}
AREA=${3}

case "$AREA" in
  "jp" )
    REGION="ap-northeast-1"
    ;;
  * )
    echo "$AREA is not exist."
    exit 1
    ;;
esac

case "$ENVIRONMENT" in
  "dev" | "ver" | "prod")
    ;;
  * )
    echo "$ENVIRONMENT is not exist."
    exit 1
    ;;
esac

echo "[設定値一覧]"
set | grep PROFILE=
set | grep ENVIRONMENT=
set | grep AREA=
set | grep REGION=

echo -e "\e[32mスクリプトを実行します [y/N]:\e[m" && read isExec
if [ $isExec = "y" ]; then :; else echo -e "\e[33mスクリプトの実行を中止しました\e[m" && exit 1; fi

echo "Create Template Bucket..."
aws s3api create-bucket \
--bucket inv-${ENVIRONMENT}-${AREA}-s3-template \
--profile ${PROFILE} \
--region ${REGION} \
--create-bucket-configuration LocationConstraint=${REGION}



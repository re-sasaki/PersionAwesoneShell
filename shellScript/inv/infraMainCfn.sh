#!/bin/bash

# echo -n "AWS Profile名を入力してください: " && read PROFILE
# echo -n "環境名(ENVIRONMENT)を入力してください[dev/ver/prd]: " && read ENVIRONMENT
# echo -n "地域(AREA)を入力してください[jp]: " && read AREA

PROFILE=${1}
ENVIRONMENT=${2}
AREA=${3}
OPERATION=${4}

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
set | grep OPERATION=

echo -e "\e[32mスクリプトを実行します [y/N]:\e[m" && read isExec
if [ $isExec = "y" ]; then :; else echo -e "\e[33mスクリプトの実行を中止しました\e[m" && exit 1; fi

BUCKET="inv-${ENVIRONMENT}-${AREA}-s3-template"
PREFIX="inv-${ENVIRONMENT}-${AREA}-cdc-infraMain"

aws cloudformation ${OPERATION}-stack \
--template-url "https://s3-ap-northeast-1.amazonaws.com/${BUCKET}/${PREFIX}/main.yml" \
--capabilities "CAPABILITY_NAMED_IAM" \
--stack-name "infraMain" \
--profile ${PROFILE} \
--parameters \
ParameterKey="area",ParameterValue=${AREA} \
ParameterKey="environment",ParameterValue=${ENVIRONMENT} \
ParameterKey="templateBucketName",ParameterValue="${BUCKET}" \
ParameterKey="templateKeyPrefix",ParameterValue="${PREFIX}" \
ParameterKey="internalHostedZoneId",ParameterValue="Z1YUVWHMSG4A4G" \
ParameterKey="publicHostedZoneId",ParameterValue="Z25Z4PYII54ETC" \
ParameterKey="acmArn",ParameterValue="arn:aws:acm:ap-northeast-1:648761380565:certificate/616d0436-3e7d-4d9b-8811-29e4fa16c0e5"

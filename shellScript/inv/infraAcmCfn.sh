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

aws cloudformation update-stack \
--template-url "https://s3-ap-northeast-1.amazonaws.com/inv-dev-jp-s3-template/inv-dev-jp-cdc-infraMain/mainCustomDomain.yml" \
--capabilities "CAPABILITY_NAMED_IAM" \
--stack-name "infraAcm" \
--profile ${PROFILE} \
--parameters \
ParameterKey="area",ParameterValue=${AREA} \
ParameterKey="environment",ParameterValue=${ENVIRONMENT} \
ParameterKey="templateBucketName",ParameterValue="inv-${ENVIRONMENT}-${AREA}-s3-template" \
ParameterKey="templateKeyPrefix",ParameterValue="inv-${ENVIRONMENT}-${AREA}-cdc-infraMain" \
ParameterKey="hostedZoneId",ParameterValue="Z25Z4PYII54ETC" \
ParameterKey="acmArn",ParameterValue="arn:aws:acm:ap-northeast-1:648761380565:certificate/14d1f828-d784-415c-b101-214346bfdc7d"


# ACM:*.dev-esp.cloud.internavi.ne.jp
# ParameterKey="acmArn",ParameterValue="arn:aws:acm:ap-northeast-1:648761380565:certificate/575a0a0b-af97-40f6-a370-5ec5cf347c88" 
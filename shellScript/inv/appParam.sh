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


json=\
'[
    {
        "key":"/api/account_info/get_authority_status/s_alert",
        "value": {
            "dev":"s-SAL001P017",
            "ver":"s-SAL001P017",
            "prd":"s-SAL001P017"
        }
    },
    {
        "key":"/api/account_info/get_authority_status",
        "value":{
            "dev":"s-RAS001P009",
            "ver":"s-RAS001P009",
            "prd":"s-RAS001P009"
        }
    },
    {
        "key":"/api/account_info/ref_id_info/basic_auth_id",
        "value":{
            "dev":"basicID",
            "ver":"basicID",
            "prd":"basicID"
        }
    },
    {
        "key":"/api/account_info/ref_id_info/basic_auth_pass",
        "value":{
            "dev":"basicPASS",
            "ver":"basicPASS",
            "prd":"basicPASS"
        }
    }
]'

json_len=$(echo $json | jq length)

for i in `seq $json_len`; do 
    param=$(echo $json | jq ".[$(($i-1))]")
    param_name=$(echo $param | jq -r ".key")
    param_value=$(echo $param | jq -r ".value | .$ENVIRONMENT")
    
    echo "put-parameter... Name:$param_name, Value:$param_value"
    aws ssm put-parameter \
    --name $param_name \
    --value $param_value \
    --type SecureString \
    --overwrite \
    --region $REGION --profile $PROFILE 
done 
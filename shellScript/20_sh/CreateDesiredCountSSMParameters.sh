#!/bin/bash
conf=`cat ${1}`
REGION=`echo $conf | jq -r '.Target[].Region'` && set | grep REGION=
ENVIRONMENT=`echo $conf | jq -r '.Target[].Environment'` && set | grep ENVIRONMENT=
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=

bash Confirm.sh || exit 1

case "$ENVIRONMENT" in
  "dj" )
    arg_list=("ARGAP" "ARGWEB" "CNSAP" "CNSWEB" "ARGTEST" "EXSYSMOCK")
    vms_list=("GW" "MFAPI" "MFASY" "MSSRV" "VFAPI" "VFASY" "VSRV")
    ;;
  "di" )
    arg_list=("ARGAP" "ARGWEB" "ARGTEST" "EXSYSMOCK")
    vms_list=("GW" "MFAPI" "MFASY" "MSSRV" "VFAPI" "VFASY" "VSRV")
    ;;
  "ds" )
    arg_list=("CNSAP" "CNSWEB")
    vms_list=()
    ;;
  "qj" | "d1" | "q1" | "t")
    arg_list=("ARGAP" "ARGWEB" "CNSAP" "CNSWEB" "ARGTEST" "EXSYSMOCK")
    vms_list=("GW" "MFAPI" "MFASY" "MSSRV" "VFAPI" "VFASY" "VSRV")
    ;;
  * )
    echo "$ENVIRONMENT is not exist."
    exit 1
    ;;
esac

for l in ${arg_list[@]}; do
  echo "Create SSM parameter. \"/Argos2/$l/$ENVIRONMENT/Plain/ECS/DesiredCount\""
  aws ssm put-parameter \
  --name "/Argos2/$l/$ENVIRONMENT/Plain/ECS/DesiredCount" \
  --value 0 \
  --type String \
  --region $REGION --profile $PROFILE
done

for l in ${vms_list[@]}; do
  echo "Create SSM parameter. \"/VMS/$l/$ENVIRONMENT/Plain/ECS/DesiredCount\""
  aws ssm put-parameter \
  --name "/VMS/$l/$ENVIRONMENT/Plain/ECS/DesiredCount" \
  --value 0 \
  --type String \
  --region $REGION --profile $PROFILE
done
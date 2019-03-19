#!/bin/bash
conf=`cat ${1}`
REGION=`echo $conf | jq -r '.Target[].Region'` && set | grep REGION=
ENVIRONMENT=`echo $conf | jq -r '.Target[].Environment'` && set | grep ENVIRONMENT=
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=

bash Confirm.sh || exit 1

case "$ENVIRONMENT" in
  "dj" )
    arg_list=("ARGAP" "ARGWEB" "CNSAP" "CNSWEB" "EXSYSMOCK" "ARGTEST")
    vms_list=("GW" "MFAPI" "MFASY" "MSSRV" "VFAPI" "VFASY" "VSRV")
    ;;
  "di" )
    arg_list=("ARGAP" "ARGWEB" "EXSYSMOCK" "ARGTEST")
    vms_list=("GW" "MFAPI" "MFASY" "MSSRV" "VFAPI" "VFASY" "VSRV")
    ;;
  "ds" )
    arg_list=("CNSAP" "CNSWEB" "ARGTEST")
    vms_list=()
    ;;
  "qj" | "d1" | "q1" | "t")
    arg_list=("ARGAP" "ARGWEB" "CNSAP" "CNSWEB" "EXSYSMOCK" "ARGTEST")
    vms_list=("GW" "MFAPI" "MFASY" "MSSRV" "VFAPI" "VFASY" "VSRV")
    ;;
  * )
    echo "$ENVIRONMENT is not exist."
    exit 1
    ;;
esac

for l in ${arg_list[@]}; do
  echo "Create SSM parameter. \"/Argos2/$l/$ENVIRONMENT/Plain/ECR/Tag\""
  aws ssm put-parameter \
  --name "/Argos2/$l/$ENVIRONMENT/Plain/ECR/Tag" \
  --value Deploy_${ENVIRONMENT}_000000000000 \
  --type String \
  --region $REGION --profile $PROFILE
done

for l in ${vms_list[@]}; do
  echo "Create SSM parameter. \"/VMS/$l/$ENVIRONMENT/Plain/ECR/Tag\""
  aws ssm put-parameter \
  --name "/VMS/$l/$ENVIRONMENT/Plain/ECR/Tag" \
  --value Deploy_${ENVIRONMENT}_000000000000 \
  --type String \
  --region $REGION --profile $PROFILE
done

# for l in ${arg_list[@]}; do
#   aws ssm get-parameter --name "/Argos2/$l/$ENVIRONMENT/Palin/ECR/Tag" --profile $PROFILE | jq ".Parameter | {Name: .Name, Value: .Value}"
# done
#
# for l in ${vms_list[@]}; do
#   aws ssm get-parameter --name "/VMS/$l/$ENVIRONMENT/Palin/ECR/Tag"  --profile $PROFILE | jq ".Parameter | {Name: .Name, Value: .Value}"
# done

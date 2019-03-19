#!/bin/bash
conf=`cat ${1}`
REGION=`echo $conf | jq -r '.Target[].Region'` && set | grep REGION=
AREA=`echo $conf | jq -r '.Target[].Area'` && set | grep AREA=
ENVIRONMENT=`echo $conf | jq -r '.Target[].Environment'` && set | grep ENVIRONMENT=
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=
PROFILE_GTC=`echo $conf | jq -r '.GTC[].Profile'` && set | grep PROFILE_GTC=
HOSTZONE_ID=`echo $conf | jq -r '.GTC[].OuterHostedZoneId'` && set | grep HOSTZONE_ID=

bash Confirm.sh || exit 1

SUB_DOMAIN=("auth" "vapi" "pub" "pri" "go" "vapilb" "publb" "prilb" "arglb")

SUBDOMAIN_HOSTZONE_IDS=$(aws route53 list-hosted-zones-by-name --dns-name $ENVIRONMENT.$AREA.gtc20.com. --profile $PROFILE | jq -r ".HostedZones[] | if .Config.PrivateZone == "false" then .Id else empty end" | sed "s|/hostedzone/||")

for s in ${SUBDOMAIN_HOSTZONE_IDS[@]};do
  name=$(aws route53 get-hosted-zone --id $s --profile $PROFILE | jq -r ".HostedZone.Name")
  if [ $name == $ENVIRONMENT.$AREA.gtc20.com. ]; then 
    SUBDOMAIN_HOSTZONE_ID=$s
    break 
  fi
done

for sd in ${SUB_DOMAIN[@]}; do
  echo "Request Certificate by $sd.$ENVIRONMENT.$AREA.gtc20.com..."
  certArn=$(aws acm request-certificate --domain-name $sd.$ENVIRONMENT.$AREA.gtc20.com \
  --validation-method DNS --profile $PROFILE --region $REGION | \
  jq -r '.CertificateArn')

  while :; do
    cert=$(aws acm describe-certificate --certificate-arn $certArn \
    --profile $PROFILE --region $REGION | \
    jq -r '.Certificate.DomainValidationOptions[].ResourceRecord')
    NAME=`echo $cert | jq -r '.Name'`
    VALUE=`echo $cert | jq -r '.Value'`
    TYPE=`echo $cert | jq -r '.Type'`
    if [ ${VALUE} != "null" ]; then
      break
    fi
  done
  
  cat << EOS > ChangeResourceRecordSet.json 
  {
    "Changes": [
      {
        "Action": "CREATE",
        "ResourceRecordSet": {
          "Name": "$NAME",
          "Type": "$TYPE",
          "TTL": 300,
          "ResourceRecords": [
            {
              "Value": "$VALUE"
            }
          ]
        }
      }
    ]
  }
EOS

  echo "Change ResourceRecordSets..."
  if [ "$SUBDOMAIN_HOSTZONE_ID" = "" ]; then
    aws route53 change-resource-record-sets --hosted-zone-id "$HOSTZONE_ID" \
    --change-batch file://ChangeResourceRecordSet.json --profile $PROFILE_GTC
  else
    aws route53 change-resource-record-sets --hosted-zone-id "$SUBDOMAIN_HOSTZONE_ID" \
    --change-batch file://ChangeResourceRecordSet.json --profile $PROFILE
  fi
done

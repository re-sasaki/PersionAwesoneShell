#!/bin/bash
conf=`cat ${1}`
AREA=`echo $conf | jq -r '.Target[].Area'` && set | grep AREA=
ENVIRONMENT=`echo $conf | jq -r '.Target[].Environment'` && set | grep ENVIRONMENT=
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=
PROFILE_GTC=`echo $conf | jq -r '.GTC[].Profile'` && set | grep PROFILE_GTC=
HOSTZONE_ID=`echo $conf | jq -r '.GTC[].OuterHostedZoneId'` && set | grep HOSTZONE_ID=

bash Confirm.sh || exit 1

echo "Create Hosted Zone..."

cr=`date +%s`

response=\
$(aws route53 create-hosted-zone \
--name $ENVIRONMENT.$AREA.gtc20.com --caller-reference $cr \
--profile $PROFILE)

NS=`echo $response | jq -r '.DelegationSet.NameServers[]'`

NSarray=(${NS[0]})

cat << EOS > ChangeResourceRecordSet.json 
{
  "Changes": [
    {
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "$ENVIRONMENT.$AREA.gtc20.com.",
        "Type": "NS",
        "TTL": 172800,
        "ResourceRecords": [
          {
            "Value": "${NSarray[0]}"
          },
          {
            "Value": "${NSarray[1]}"
          },
          {
            "Value": "${NSarray[2]}"
          },
          {
            "Value": "${NSarray[3]}"
          }
        ]
      }
    }
  ]
}
EOS

aws route53 change-resource-record-sets --hosted-zone-id $HOSTZONE_ID \
--change-batch file://ChangeResourceRecordSet.json --profile $PROFILE_GTC

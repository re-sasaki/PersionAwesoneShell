#!/bin/bash
conf=`cat ${1}`
AREA=`echo $conf | jq -r '.Target[].Area'` && set | grep AREA=
ENVIRONMENT=`echo $conf | jq -r '.Target[].Environment'` && set | grep ENVIRONMENT=
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=

bash Confirm.sh || exit 1

echo "Verify Domain by SES"

TOKEN=$(aws ses verify-domain-identity --domain $ENVIRONMENT.$AREA.gtc20.com --profile $PROFILE --region us-east-1 | jq -r ".VerificationToken")

TOKEN=\\\"$TOKEN\\\"

cat << EOS > ChangeResourceRecordSet.json
{
  "Changes": [
    {
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "_amazonses.$ENVIRONMENT.$AREA.gtc20.com.",
        "Type": "TXT",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "$TOKEN"
          }
        ]
      }
    }
  ]
}
EOS

SUBDOMAIN_HOSTZONE_ID=$(aws route53 list-hosted-zones-by-name --dns-name $ENVIRONMENT.$AREA.gtc20.com --profile $PROFILE | jq -r ".HostedZones[].Id" | sed "s|/hostedzone/||")

aws route53 change-resource-record-sets --hosted-zone-id $SUBDOMAIN_HOSTZONE_ID \
--change-batch file://ChangeResourceRecordSet.json --profile $PROFILE

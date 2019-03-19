#!/bin/bash
conf=`cat ${1}`
REGION=`echo $conf | jq -r '.Target[].Region'` && set | grep REGION=
AREA=`echo $conf | jq -r '.Target[].Area'` && set | grep AREA=
ENVIRONMENT=`echo $conf | jq -r '.Target[].Environment'` && set | grep ENVIRONMENT=
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=

bash Confirm.sh || exit 1

echo "Put deploy.json&dummytrigger.zip..."

list=(`cat appList.txt | xargs`)

for l in ${list[@]}; do
  app=(`echo ${l//-*/}`)
  echo "Put to s3://gtc-$ENVIRONMENT-$AREA-s3-cdp-$app-artifactstore/Deploy/$ENVIRONMENT-$AREA/$l/..."
  aws s3 cp Deploy/ \
  s3://gtc-$ENVIRONMENT-$AREA-s3-cdp-$app-artifactstore/Deploy/$ENVIRONMENT-$AREA/$l/ \
  --recursive --profile $PROFILE --region $REGION
done

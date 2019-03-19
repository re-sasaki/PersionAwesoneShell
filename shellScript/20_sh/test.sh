#!/bin/bash
conf=`cat ${1}`
REGION=`echo $conf | jq -r '.Target[].Region'` && set | grep REGION=
AREA=`echo $conf | jq -r '.Target[].Area'` && set | grep AREA=
ENVIRONMENT=`echo $conf | jq -r '.Target[].Environment'` && set | grep ENVIRONMENT=
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=
PROFILE_DEV=`echo $conf | jq -r '.DEV_JAST[].Profile'` && set | grep PROFILE_DEV=

app=("vms" "daq" "argos2")

for APP in ${app[@]}; do  
  list=$(aws s3api list-objects-v2 --bucket gtc-$ENVIRONMENT-$AREA-s3-cdp-$APP-artifactstore --profile $PROFILE --prefix Deploy/$ENVIRONMENT-$AREA | jq -r ".Contents[].Key")
  
  for l in ${list[@]}; do
    echo $l |sed "s|Deploy/d1-jp/||g" | sed "s|/.*$||g" >> list.txt
  done
  
  list2=(`cat list.txt | sort | uniq | xargs`)
  
  for l in ${list2[@]}; do
    echo "Put to s3://gtc-$ENVIRONMENT-$AREA-s3-cdp-$APP-artifactstore/Deploy/$ENVIRONMENT-$AREA/$l/..."
    aws s3 cp $repoName/Deploy/ \
    s3://gtc-$ENVIRONMENT-$AREA-s3-cdp-$APP-artifactstore/Deploy/$ENVIRONMENT-$AREA/$l/ \
    --recursive --profile $PROFILE --region $REGION
  done
done

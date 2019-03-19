#!/bin/bash
conf=`cat ${1}`
REGION=`echo $conf | jq -r '.Target[].Region'` && set | grep REGION=
AREA=`echo $conf | jq -r '.Target[].Area'` && set | grep AREA=
ENVIRONMENT=`echo $conf | jq -r '.Target[].Environment'` && set | grep ENVIRONMENT=
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=

bash Confirm.sh || exit 1

applist="vms daq argos2"

echo "選択してください"
for al in ${applist[@]} ; do
  echo $al
done

read App

case "$App" in
  "vms" )
  list=(`cat appList.txt | grep 'vms-'`)
  ;;
  "daq" )
  list=(`cat appList.txt | grep 'daq-'`)
  ;;
  "argos2" )
  list=(`cat appList.txt | grep 'argos2-'`)
  ;;
  * )  
  echo "入力値が不正です"
  exit 1
  ;;
esac

i=1
echo "数字を選択してください"
for v in ${list[@]} ; do
  echo $i ${list[$i-1]}
  let i++
done
read isNo
if [ "${list[$isNo-1]}" != "" -a $isNo -gt 0 ]; then
  appIndentidier=${list[$isNo-1]}
  echo "$appIndentidierが選択されました。"
else
  echo "入力値が不正です。"
  exit 1
fi

echo "Put deploy.json&dummytrigger.zip ..."
echo "Put to s3://gtc-$ENVIRONMENT-$AREA-s3-cdp-$App-artifactstore/Deploy/$ENVIRONMENT-$AREA/$appIndentidier/"
echo "Putしますか[Y/n]:"
read isExec
if [ $isExec = "Y" ]; then
  :
else
  echo "スクリプトの実行を中止しました"
  exit 1
fi

aws s3 cp Deploy/ \
s3://gtc-$ENVIRONMENT-$AREA-s3-cdp-$App-artifactstore/Deploy/$ENVIRONMENT-$AREA/$appIndentidier/ \
--recursive --profile $PROFILE --region $REGION
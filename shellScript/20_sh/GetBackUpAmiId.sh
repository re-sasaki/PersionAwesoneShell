#!/bin/bash
conf=`cat ${1}`
REGION=`echo $conf | jq -r '.Target[].Region'` && set | grep REGION=
AREA=`echo $conf | jq -r '.Target[].Area'` && set | grep AREA=
ENVIRONMENT=`echo $conf | jq -r '.Target[].Environment'` && set | grep ENVIRONMENT=
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=
ENVIRONMENT_DEV=`echo $conf | jq -r '.DEV_JAST[].Environment'` && set | grep ENVIRONMENT_DEV=

bash Confirm.sh || exit 1

get_no=`echo ${2}`
if [ -z $get_no ]; then
  get_no=0
fi

echo "Get Backup AMI's ID for Redmine ..."
# Get AMI's CreateTime
time_list=$(aws ec2 describe-images --filters "Name=tag:Name,Values=RedmineBuckupImage" --query 'Images[].Tags[?Key == `CreateTime`]'.Value --output=text --profile $PROFILE --region $REGION)
for time in $time_list; do
  echo $time >> timelist.txt
done
# CreateTime List Sort
array2=(`cat timelist.txt | sort -r`)
# echo ${array2[@]}
get_time=$(echo ${array2[$get_no]})
# echo $get_time
rm timelist.txt

# Create Describe Messege
Name=$(aws ec2 describe-images --filters "Name=tag:CreateTime,Values=$get_time" --profile $PROFILE  --query 'Images[].Name' --output text)
echo $Name > ami_name.txt
sed -ie "s/redmine-bkup /Created on /" ami_name.txt
getName=`cat ami_name.txt`
rm ami_name.txt

# Get AMI ID
echo "AMI ID is [`aws ec2 describe-images --filters "Name=tag:CreateTime,Values=$get_time" --profile $PROFILE  --query 'Images[].ImageId' --output text`]. $getName"

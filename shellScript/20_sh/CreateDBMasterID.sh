#!/bin/bash
conf=`cat ${1}`
REGION=`echo $conf | jq -r '.Target[].Region'` && set | grep REGION=
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=
ENVIRONMENT=`echo $conf | jq -r '.Target[].Environment'` && set | grep ENVIRONMENT=

bash Confirm.sh || exit 1

echo "Create DB MasterUser ParameterStore..."
aws ssm put-parameter --name vms-rds-masteruser --type SecureString --value rds_com_admin --region $REGION --profile $PROFILE
aws ssm put-parameter --name daq-rds-masteruser --type SecureString --value rds_daq_admin --region $REGION --profile $PROFILE
aws ssm put-parameter --name argos2-rds-masteruser --type SecureString --value rds_arg_admin --region $REGION --profile $PROFILE

echo "Create DB MasterPass ParameterStore..."
echo "[VMS]Passwordを入力してください"
read PASSWORD
aws ssm put-parameter --name vms-rds-masterpass --type SecureString --value $PASSWORD --region $REGION --profile $PROFILE

echo "[DAQ]Passwordを入力してください"
read PASSWORD
aws ssm put-parameter --name daq-rds-masterpass --type SecureString --value $PASSWORD --region $REGION --profile $PROFILE

echo "[Argos2]Passwordを入力してください"
read PASSWORD
aws ssm put-parameter --name argos2-rds-masterpass --type SecureString --value $PASSWORD --region $REGION --profile $PROFILE



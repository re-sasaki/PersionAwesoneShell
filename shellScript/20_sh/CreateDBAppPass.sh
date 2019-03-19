#!/bin/bash
conf=`cat ${1}`
REGION=`echo $conf | jq -r '.Target[].Region'` && set | grep REGION=
PROFILE=`echo $conf | jq -r '.Target[].Profile'` && set | grep PROFILE=
ENVIRONMENT=`echo $conf | jq -r '.Target[].Environment'` && set | grep ENVIRONMENT=

bash Confirm.sh || exit 1

echo "Create Parameter DB Password for App..."
masterPass=$(aws ssm get-parameter --name vms-rds-masterpass --with-decryption --region $REGION --profile $PROFILE | jq -r ".Parameter.Value")
aws ssm put-parameter --name /VMS/MSSVC/$ENVIRONMENT/Secure/RDS/CMN/Password --type SecureString --value $masterPass --region $REGION --profile $PROFILE
aws ssm put-parameter --name /VMS/VESVC/$ENVIRONMENT/Secure/RDS/CMN/Password --type SecureString --value $masterPass --region $REGION --profile $PROFILE
aws ssm put-parameter --name /Argos2/ARGAP/$ENVIRONMENT/Secure/RDS/CMN/Password --type SecureString --value $masterPass --region $REGION --profile $PROFILE
aws ssm put-parameter --name /Argos2/ARGTEST/$ENVIRONMENT/Secure/RDS/CMN/Password --type SecureString --value $masterPass --region $REGION --profile $PROFILE
aws ssm put-parameter --name /Argos2/EXSYSMOCK/$ENVIRONMENT/Secure/RDS/CMN/Password --type SecureString --value $masterPass --region $REGION --profile $PROFILE

masterPass=$(aws ssm get-parameter --name daq-rds-masterpass --with-decryption --region $REGION --profile $PROFILE | jq -r ".Parameter.Value")
aws ssm put-parameter --name /Argos2/CNSAP/$ENVIRONMENT/Secure/RDS/DLK/Password --type SecureString --value $masterPass --region $REGION --profile $PROFILE
aws ssm put-parameter --name /DAQ/LMDAQLOG/$ENVIRONMENT/Secure/RDS/Password --type SecureString --value $masterPass --region $REGION --profile $PROFILE
aws ssm put-parameter --name /DAQ/LMDIG/$ENVIRONMENT/Secure/RDS/Password --type SecureString --value $masterPass --region $REGION --profile $PROFILE
aws ssm put-parameter --name /DAQ/LMFCD/$ENVIRONMENT/Secure/RDS/Password --type SecureString --value $masterPass --region $REGION --profile $PROFILE
aws ssm put-parameter --name /DAQ/LMSNP/$ENVIRONMENT/Secure/RDS/Password --type SecureString --value $masterPass --region $REGION --profile $PROFILE
aws ssm put-parameter --name /DAQ/LMTS/$ENVIRONMENT/Secure/RDS/Password --type SecureString --value $masterPass --region $REGION --profile $PROFILE

masterPass=$(aws ssm get-parameter --name argos2-rds-masterpass --with-decryption --region $REGION --profile $PROFILE | jq -r ".Parameter.Value")
aws ssm put-parameter --name /Argos2/ARGAP/$ENVIRONMENT/Secure/RDS/ARG/Password --type SecureString --value $masterPass --region $REGION --profile $PROFILE
aws ssm put-parameter --name /Argos2/CNSAP/$ENVIRONMENT/Secure/RDS/ARG/Password --type SecureString --value $masterPass --region $REGION --profile $PROFILE
aws ssm put-parameter --name /Argos2/ARGTEST/$ENVIRONMENT/Secure/RDS/ARG/Password --type SecureString --value $masterPass --region $REGION --profile $PROFILE
aws ssm put-parameter --name /Argos2/EXSYSMOCK/$ENVIRONMENT/Secure/RDS/ARG/Password --type SecureString --value $masterPass --region $REGION --profile $PROFILE
echo "[FitNesse]Passwordを入力してください"
read PASSWORD
aws ssm put-parameter --name /Argos2/ARGTEST/$ENVIRONMENT/Secure/FitNesse/Password --type SecureString --value $PASSWORD --region $REGION --profile $PROFILE
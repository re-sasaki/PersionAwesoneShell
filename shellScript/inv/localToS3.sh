#!/bin/bash

env=$1
profile=$2

aws s3 cp ./inv-dev-jp-cdc-infraMain s3://inv-$env-jp-s3-template/inv-$env-jp-cdc-infraMain --recursive --exclude ".git/*" --profile $profile
aws s3 cp ./inv-dev-jp-cdc-appPipelineMain s3://inv-$env-jp-s3-template/inv-$env-jp-cdc-appPipelineMain --recursive --exclude ".git/*" --profile $profile
aws s3 cp ./inv-dev-jp-cdc-infraSpec s3://inv-$env-jp-s3-template/inv-$env-jp-cdc-infraSpec --recursive --exclude ".git/*" --profile $profile

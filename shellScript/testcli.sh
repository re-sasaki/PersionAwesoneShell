#!/bin/bash

re=`$(aws configure list --profile 20ibm | grep region) | xargs`

for r in "${re[@]}"; do
echo $r
done

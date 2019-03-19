#!/bin/bash

PROFILE=${1}

cp ~/.gitconfig ~/.gitconfig.org

git config --global credential.helper "!aws codecommit credential-helper --profile $PROFILE"
git config --global credential.UseHttpPath true

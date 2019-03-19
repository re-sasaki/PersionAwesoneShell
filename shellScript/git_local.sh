#!/bin/bash

COMMAND=${1}
PROFILE=${2}

bash ~/shellscript/git_conf_change.sh $PROFILE

git $COMMAND

bash ~/shellscript/git_conf_reset.sh
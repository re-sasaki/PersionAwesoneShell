#!/bin/bash

PROFILE=(20jast)

prog(){
  progress() {
    sleep 1
    while :
    do
      jobs %1 > /dev/null 2>&1
      [ $? = 0 ] || break
      for char in '|' '/' '-' '\'; do
        echo -n $char && sleep 0.1 && printf "\b"
      done
    done;
  }
  usage() {
    echo "usage:$0 [command]"; exit;
  }
  [ $# = 0 ] && usage
  "$@" & progress
}

list() {
  cr=`date +%s`
  count=0
  names_list=()
  file="ssm_$cr.csv"

  echo Account, Name, Type, Value >> $file
  
  for p in ${PROFILE[@]};do
    echo "start listing $p parameters..."
    LIST=$(aws ssm describe-parameters --profile $p | jq -r ".Parameters[].Name")
    for l in ${LIST[@]};do
      names_list+=($l)
      let count++
      if [ $count -eq 10 ]; then 
        response=$(aws ssm get-parameters --names ${names_list[@]} --profile $p)
        len=`echo $response | jq ".Parameters | length"`
        let len--
        num=`eval echo {0..$len}`
        for i in $num; do
          echo -n $p >> $file
          echo -n "," >> $file
          echo $response | jq -r ".Parameters[$i].Name" | tr -d "\n" >> $file
          echo -n "," >> $file
          echo $response | jq -r ".Parameters[$i].Type" | tr -d "\n" >> $file
          echo -n "," >> $file
          echo $response | jq -r ".Parameters[$i].Value" >> $file
        done
        count=0
        names_list=()
      fi
    done
  done
  
  echo "Complete listing!"
}

prog list
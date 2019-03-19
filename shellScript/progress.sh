#!/bin/bash
prog(){
  progress() {
    while :
    do
      jobs %1 > /dev/null 2>&1
      [ $? = 0 ] || break
      for i in `seq 0 3`; do
        for char in '|' '/' '-' '\'; do
          echo -n $char
          sleep 0.1
          printf "\b"
        done
      done
    done;
  }
  
  usage() {
    echo "usage:$0 [command]"; exit;
  }
  
  [ $# = 0 ] && usage
  
  "$@" &
  progress
}

syori() {
  for i in {0..50}; do
    echo "hoge"
    sleep 10
    let i++
  done 
}

prog syori

show_spin () {
  rotations=3
  delay=0.1
  for i in `seq 0 $rotations`; do
    for char in '|' '/' '-' '\'; do
      echo -n $char
      sleep $delay
      printf "\b"
    done
  done
}

show_spin

#!/bin/sh

TGT_AREA_ARR=jp us eu th id

for a in ${TGT_AREA_ARR[@]}; do
  if ` ! echo ${TGT_AREA_ARR[@]} | grep -q "$a" `; then
    echo "Validation error: TGT_AREA is not valid. $a"
    touch validfile
  fi
done

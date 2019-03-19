#!/bin/bash

echo "スクリプトを実行します [Y/n]:"
read isExec
if [ $isExec = "Y" ]; then
  :
else
  echo "スクリプトの実行を中止しました"
  exit 1
fi

#!/bin/bash
<< COMMENT
1. これをリポジトリが複数置いてあるディレクトリに配置する
2. bashでsh all_pull.shを実行する
3. pullされる
COMMENT

current=`pwd`

for file in `find -type d -name .git`; do
    cd ${file%/.git}
    pwd
    git pull
    cd ${current}
    echo ""
done

#!/bin/bash
<< COMMENT
1. これをリポジトリが複数置いてあるディレクトリに配置する
2. bashでsh all_push.shを実行する
3. pushされる
COMMENT

PROFILE=${1}

bash ~/shellscript/git_conf_change.sh $PROFILE

current=`pwd`

for file in `find -maxdepth 2 -type d -name .git`; do
    cd ${file%/.git}
    pwd
    git push
    cd ${current}
    echo ""
done

bash ~/shellscript/git_conf_reset.sh
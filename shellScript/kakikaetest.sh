#!/bin/bash
# SYS_TAG="hoge"
# echo `date | tr '\012' ' '`: $SYS_TAG  >> DeployVersionTagHistory.txt
# # echo ": $SYS_TAG" >> DeployVersionTagHistory.txt
# 
# # cat << EOS >> template.yml
# # PutTag:
# #   Type: "AWS::SSM::Parameter"
# #   Properties:
# #     Name: !Sub /DeployVersionTag/$Env/Plain/Infra/$SSM_SYS_NAME
# #     Description: Infra GitTag
# #     Type: String
# #     Value: $SYS_TAG
# # EOS
# # 
# # hogehuga=`cat template.yml`
# # hoge="hogehoge"
# # sed -e "/^Resource:$/i $hoge" template.yml

# insertNum=`grep -e "Resource:" -n template.yml | sed -e 's/:.*//g'`
# 
# txt1="\  PutTag:"
# txt2="\    Type: \"AWS::SSM::Parameter\""
# txt3="\    Properties:"
# txt4="\      Name: !Sub /DeployVersionTag/\$Env/Plain/Infra/\$SSM_SYS_NAME"
# txt5="\      Description: Infra GitTag"
# txt6="\      Type: String"
# txt7="\      Value: \$SYS_TAG"
# 
# sed -i -e "${insertNum}a $txt7" template.yml
# sed -i -e "${insertNum}a $txt6" template.yml
# sed -i -e "${insertNum}a $txt5" template.yml
# sed -i -e "${insertNum}a $txt4" template.yml
# sed -i -e "${insertNum}a $txt3" template.yml
# sed -i -e "${insertNum}a $txt2" template.yml
# sed -i -e "${insertNum}a $txt1" template.yml


txt='\  PutTag:#n#    Type: \"AWS::SSM::Parameter\"#n#    Properties:#n#      Name: !Sub /DeployVersionTag/\$Env/Plain/Infra/\$SSM_SYS_NAME#n#      Description: Infra GitTag#n#      Type: String#n#      Value: \$SYS_TAG'
# txt="hoge"
sed -i -e s|Resources:|$txt|g template.yml
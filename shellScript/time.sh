for i in `seq 100`
do
(time aws ssm get-parameter --name sasaki_name --with-decryption --profile learn) 2>>time.log
sleep 1
done


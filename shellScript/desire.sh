desire=$(aws ecs describe-services --cluster gtc-t0-jp-ecs-cls-argos2-web --services gtc-t0-jp-ecs-service-argos2-vmsweb --profile 20m | jq -r '.services[].desiredCount')
test ${desire} -eq 0
if [ $? -eq 0 ]; then
  echo 'OK'
  #aws ecs update-service --cluster gtc-t0-jp-ecs-cls-argos2-web --service gtc-t0-jp-ecs-service-argos2-vmsweb --desired-count 0 --profile 20m
fi

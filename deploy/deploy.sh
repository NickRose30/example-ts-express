#!/usr/bin/env bash

source "$PWD/deploy/env.sh"

# if no sso access token, do login
LOGIN=$(aws ecr --profile PersonalIAM get-login-password --region us-east-1 | docker login --username AWS --password-stdin $IMAGE)
if [[ ! $LOGIN = 'Login Succeeded' ]]; then
    aws sso --profile PersonalIAM login
    aws ecr --profile PersonalIAM get-login-password --region us-east-1 | docker login --username AWS --password-stdin $IMAGE
fi

BUILD_RESULT=$(docker build -t $REPO .)
if [ $? -ne 0 ]; then
  echo "Error: $BUILD_RESULT"
  exit 1
fi

docker tag $REPO:latest $IMAGE/$REPO:latest
docker push $IMAGE/$REPO:latest

TASKDEF=$(aws ecs --profile PersonalIAM describe-task-definition --task-definition $TASK_DEFINITION --query "taskDefinition.taskDefinitionArn" | jq -r)
aws ecs --profile PersonalIAM update-service --cluster $CLUSTER --service $SERVICE --task-definition $TASKDEF --force-new-deployment 2>&1 > /dev/null

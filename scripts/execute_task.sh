#!/usr/bin/env bash

# Task Execution IAM Role
# - create the task execution role
aws iam --region us-east-1 create-role --role-name ecsTaskExecutionRole --assume-role-policy-document ./task-execution-assume-role.json --profile rainbowtext

# - attach the task execution role policy
aws iam --region us-east-1 attach-role-policy --role-name ecsTaskExecutionRole --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy --profile rainbowtext

# ECS CLI configuration
# create ecs cluster
ecs-cli configure --cluster rainbowtext --region us-east-1 --default-launch-type FARGATE --config-name rainbowtext

# create ecs profile
ecs-cli configure profile --access-key "$AWS_ACCESS_KEY_ID" --secret-key "$AWS_SECRET_ACCESS_KEY" --profile-name rainbowtext
#!/usr/bin/env bash

# cleanup ecsRainbowtextTaskExecutionRole
aws iam detach-role-policy --role-name ecsRainbowtextTaskExecutionRole --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy --profile rainbowtext
aws iam delete-role --role-name ecsRainbowtextTaskExecutionRole --profile rainbowtext

# cleanup aws log group
aws logs delete-log-group --log-group-name rainbowtext

# clean up ecr
python scripts/del_ecr.py

# clean up ecs cluster
ecs-cli compose --file docker-compose.ecs.yml --ecs-params ecs-params.ecs.yml --project-name rainbowtext service down --cluster-config rainbowtext
ecs-cli down --force --cluster-config rainbowtext
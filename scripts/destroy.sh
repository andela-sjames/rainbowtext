#!/usr/bin/env bash

# cleanup aws log group
aws logs delete-log-group --log-group-name ${AWS_PROJECT}

# clean up ecr
python scripts/del_ecr.py

# clean up ecs cluster
ecs-cli compose --file docker-compose.ecs.yml --ecs-params ecs-params.ecs.yml --project-name ${AWS_PROJECT} service down --cluster-config ${AWS_PROJECT}
ecs-cli down --force --cluster-config ${AWS_PROJECT}

# clean up role
aws iam detach-role-policy --role-name ${AWS_ROLE} --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy --profile ${AWS_PROJECT}
aws iam delete-role --role-name ${AWS_ROLE} --profile ${AWS_PROJECT}

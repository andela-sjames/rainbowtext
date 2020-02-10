#!/usr/bin/env bash
set -e


# Task Execution IAM Role
# - create the task execution role

project_name="$1"
role_name="$2"

aws iam --region ${AWS_REGION} create-role --role-name ${role_name} --assume-role-policy-document file://scripts/task-execution-assume-role.json --profile ${project_name}

# attach the task execution role policy
echo "attach the task execution role policy"
aws iam --region ${AWS_REGION} attach-role-policy --role-name ${role_name} --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy --profile ${project_name}

# ECS CLI configuration
# create ecs cluster config
echo "create ecs cluster config"
ecs-cli configure --cluster ${project_name} --region ${AWS_REGION} --default-launch-type FARGATE --config-name ${project_name}

# create ecs profile
echo "create ecs profile"
ecs-cli configure profile --access-key "$AWS_ACCESS_KEY_ID" --secret-key "$AWS_SECRET_ACCESS_KEY" --profile-name ${project_name}

# ecs-cli up
echo "ecs-cli up running"
result=$(ecs-cli up --azs ${AWS_REGION}a,${AWS_REGION}b --force --instance-role ${role_name} --cluster ${project_name})
echo "ecs-cli up done"


vpc_id=$(echo "$result" | grep -o "VPC created: .*" | cut -f2 -d ":" | xargs)
echo "vpc_id=${vpc_id}"

subnet_ids=$(echo "$result" | grep -o "Subnet created: .*" | cut -f2 -d ":" | xargs)
echo "subnet_ids=${subnet_ids}"

security_grp_id=$(aws ec2 describe-security-groups --filters Name=vpc-id,Values=${vpc_id} --region ${AWS_REGION} | jq '.SecurityGroups | .[0] | .GroupId' | tr -d '"')
echo "security_grp_id=${security_grp_id}"

# use an array
array=(${subnet_ids//,/ })
subnet_a=${array[0]}
subnet_b=${array[1]}

# call the python script with the arguments passed
python scripts/set_ecs_params.py "${vpc_id}" "${security_grp_id}" "${subnet_a}" "${subnet_b}"

# deploy to the ecs cluster
ecs-cli compose --file ${DOCKER_COMPOSE_YML_OUTPUT} --ecs-params ${ECS_PARAMS_OUTPUT} --project-name ${project_name} service up --create-log-groups --cluster-config ${project_name}

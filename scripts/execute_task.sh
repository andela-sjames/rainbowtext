#!/usr/bin/env bash

# Task Execution IAM Role
# - create the task execution role

rainbowtext="$1" 

aws iam --region us-east-1 create-role --role-name ecsRainbowtextTaskExecutionRole --assume-role-policy-document file://task-execution-assume-role.json --profile ${rainbowtext}

# - attach the task execution role policy
aws iam --region us-east-1 attach-role-policy --role-name ecsRainbowtextTaskExecutionRole --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy --profile ${rainbowtext}

# ECS CLI configuration
# create ecs cluster
ecs-cli configure --cluster ${rainbowtext} --region us-east-1 --default-launch-type FARGATE --config-name ${rainbowtext}

# create ecs profile
ecs-cli configure profile --access-key "$AWS_ACCESS_KEY_ID" --secret-key "$AWS_SECRET_ACCESS_KEY" --profile-name ${rainbowtext}

# ecs-cli up
result=$(ecs-cli up --instance-role ecsRainbowtextTaskExecutionRole --cluster ${rainbowtext})

echo $result
                          
# time="2019-07-02T02:43:36+01:00" level=warning msg="You will not be able to SSH into your EC2 instances without a key pair."
# time="2019-07-02T02:43:37+01:00" level=info msg="Defaulting instance type to t2.micro"
# time="2019-07-02T02:43:39+01:00" level=info msg="Using recommended Amazon Linux 2 AMI with ECS Agent 1.29.0 and Docker version 18.06.1-ce"
# time="2019-07-02T02:43:40+01:00" level=info msg="Created cluster" cluster=sample-ecr-bookshelf-cluster region=us-east-1
# time="2019-07-02T02:43:41+01:00" level=info msg="Waiting for your cluster resources to be created..."
# time="2019-07-02T02:43:42+01:00" level=info msg="Cloudformation stack status" stackStatus=CREATE_IN_PROGRESS
# time="2019-07-02T02:44:45+01:00" level=info msg="Cloudformation stack status" stackStatus=CREATE_IN_PROGRESS
# time="2019-07-02T02:45:48+01:00" level=info msg="Cloudformation stack status" stackStatus=CREATE_IN_PROGRESS
# VPC created: vpc-015fd09ddfaf2dfad
# Security Group created: sg-0b1cbea67f8fdb82f
# Subnet created: subnet-02626a8fad33d9d10
# Subnet created: subnet-086b27f3c0e269894
# Cluster creation succeeded.


# delete cluster
# aws ecs delete-cluster --cluster ${rainbowtext}


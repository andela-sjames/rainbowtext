#!/usr/bin/env bash

# loging to ecr
scripts/login_ecr.sh

# setup ecr and upload to ecr
python scripts/config_ecr.py

# setup ecs and deploy to ecs fargate
scripts/setup_ecs.sh ${AWS_PROJECT} ${AWS_ROLE}

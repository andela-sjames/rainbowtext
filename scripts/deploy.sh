#!/usr/bin/env bash

# loging to ecr
scripts/login_ecr.sh

# setup ecr and upload to ecr
python scripts/config_ecr.py

# setup ecs and deploy to ecs
scripts/setup_ecs.sh rainbowtext

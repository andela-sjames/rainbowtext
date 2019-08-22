# rainbowtext

A mini Flask App to demonstrate auto deploy to AWS-ECS Fargate with Docker-Compose

Project Folder Structure.

```text
- nginx
    | - check.sh
    | - dockerfile
    | - nginx.conf
    | - nginx.dev.conf
- scripts
    | - .env (ignored)
    | - config_ecr.py
    | - del_ecr.py
    | - deploy.sh
    | - destroy.sh
    | - login_ecr.sh
    | - set_ecs_params.py
    | - setup_ecs.sh
    | - task-execution-assume-role.json
- templates
    | - home.html
- .gitignore
- app.py
- docker-compose.ecs.yml(generated and ignored)
- docker-compose.yml
- dockerfile
- ecs-params.yml
- ecs-params.ecs.yml (generated and ignored)
- instructions.txt
- LICENSE
- README.md
- requirements.txt
- uwsgi.ini
```

`.env` file should be placed in your `scripts` folder.
*run `source scripts/.env` to load your environment variables*

```shell
export AWS_ACCOUNT_ID=<YOUR_AWS_IAM_ACCOUNT_ID>
export AWS_REGION=us-east-1

export DOCKER_COMPOSE_YML_INPUT=docker-compose.yml
export DOCKER_COMPOSE_YML_OUTPUT=docker-compose.ecs.yml

export ECS_PARAMS_INPUT=ecs-params.yml
export ECS_PARAMS_OUTPUT=ecs-params.ecs.yml

export AWS_ACCESS_KEY_ID=<YOUR_AWS_IAM_ACCESS_KEY_ID>
export AWS_SECRET_ACCESS_KEY=<YOUR_AWS_IAM_SECRET_ACCESS_KEY>

```

This project makes use of Docker to automate deployment to AWS ECS FARGATE.

## Build and run locally

```shell
docker-compose build && docker-compose up
```

Navigate to `localhost` to see the running application.

## Build for production

```shell
docker-compose build --build-arg build_env="production"
```

## Deploy to production

```shell
./scripts/deploy.sh
```

## Build for production and deploy

```shell
docker-compose build --build-arg build_env="production" && ./scripts/deploy.sh
```

## Deploy to ECS Fargate

```shell
scripts/deploy.sh
```

## Destroy after testing app

```shell
scripts/destroy.sh
```

### Other instructions

`instructions.txt`

### Some context here if you don't mind

The Deploy script does three basic things using three files

- `scripts/login_ecr.sh`: It configures aws on your machine with a custom profile and logs into ECR.
- `scripts/config_ecr.py`: It creates a repo on ecr and uploads created and tagged images to ECR.
- `scripts/setup_ecs.sh rainbowtext`: Setup ECS and deploy to ECS fargate.

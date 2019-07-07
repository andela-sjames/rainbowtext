# rainbowtext
A mini Flask App to demonstrate auto deploy to AWS-ECS Fargate with Docker-Compose

Project Structure.
```
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

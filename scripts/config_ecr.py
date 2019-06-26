import os
import subprocess
import time
import yaml
import re

import boto3

client = boto3.client('ecr')

AWS_ACCOUNT_ID = os.getenv('AWS_ACCOUNT_ID', 'your_AWS_id')
AWS_REGION = os.getenv('AWS_REGION', 'your_aws_region')

# Get the name of the current directory
PROJECT_NAME = os.path.basename(os.path.realpath("."))

# use if repository exist
SERVER_REPOSITORY_URI = f'{AWS_ACCOUNT_ID}.dkr.ecr.{AWS_REGION}.amazonaws.com/{PROJECT_NAME}_server'
NGINX_REPOSITORY_URI = f'{AWS_ACCOUNT_ID}.dkr.ecr.{AWS_REGION}.amazonaws.com/{PROJECT_NAME}_nginx'

ECR_REPO_OBJ = {
    f"{PROJECT_NAME}_server": SERVER_REPOSITORY_URI,
    f"{PROJECT_NAME}_nginx": NGINX_REPOSITORY_URI
}

push_operations = dict()

# Generate version number for build
version = str(int(time.time()))

input_file = os.environ.get("DOCKER_COMPOSE_YML_INPUT", "docker-compose.yml")
output_file = os.environ.get("DOCKER_COMPOSE_YML_OUTPUT", "docker-compose.yml-{}".format(version))

if input_file == output_file == "docker-compose.yml":
    print("I will not clobber your docker-compose.yml file.")
    print("Please unset DOCKER_COMPOSE_YML or set it to something else.")
    exit(1)

print(PROJECT_NAME, output_file, "The project name")

stack = yaml.safe_load(open(input_file))
services = stack["services"]


# create repository
def create_ecr_repo(services):
    obj = {}

    for service_name, service in services.items():
        if "build" in service:
            # create repository
            ecr_repository_name = f'{PROJECT_NAME.lower()}_{service_name}'
            try:
                response = client.create_repository(
                    repositoryName=ecr_repository_name,
                    tags=[
                        {
                            'Key': 'platform',
                            'Value': service_name
                        },
                    ]
                )

                ecr_uri = response['repository']['repositoryUri']
                obj[ecr_repository_name] = ecr_uri
            except Exception as e:
                return None
    return obj


def tag(ecr_repo_obj):
    for key, value in ecr_repo_obj.items():
        original_tag = f'{key}:latest'
        new_tag = f'{value}:latest'
        subprocess.check_call(["docker", "tag", original_tag, new_tag])


def push(ecr_repo_obj):
    for key, value in ecr_repo_obj.items():
        new_tag = f'{value}:latest'
        push = subprocess.Popen(["docker", "push", new_tag])
        status = f"Waiting for {key} push to complete..."
        print(status)
        push.wait()
        print("Done.")


def update(service_name, service, ecr_repo_obj):
    for key, value in ecr_repo_obj.items():
        if service_name in key:
            del service["build"]
            service["image"] = value


def re_tag_images(ecr_repo_obj=None):
    if ecr_repo_obj is None:
        ecr_repo_obj = ECR_REPO_OBJ
    tag(ecr_repo_obj)


def push_to_ecr(ecr_repo_obj=None):
    if ecr_repo_obj is None:
        ecr_repo_obj = ECR_REPO_OBJ
    push(ECR_REPO_OBJ)


def update_services(ecr_repo_obj=None):
    # Replace the "build" definition by an "image" definition,
    # using the name of the image on ECR.
    global services
    if ecr_repo_obj is None:
        ecr_repo_obj = ECR_REPO_OBJ

    for service_name, service in services.items():
        if "build" in service:
            update(service_name, service, ecr_repo_obj)

        if "volumes" in service:
            del service["volumes"]

    print(services, "the service")


# Write the new docker-compose.yml file.
def create_deploy_docker_compose_file(output_file):
    with open(output_file, "w") as out_file:
        yaml.safe_dump(stack, out_file, default_flow_style=False)

    # yaml that is produced is a bit buggy.
    fh = open(output_file, "r+")
    lines = map(lambda a: re.sub(r"^\s{4}-", "      -", a), fh.readlines())
    fh.close()
    with open(output_file, "w") as f:
        f.writelines(lines)


print("Wrote new compose file.")
print(f"COMPOSE_FILE={output_file}")

res = create_ecr_repo(services)
re_tag_images(res)
push_to_ecr(res)
update_services(res)

create_deploy_docker_compose_file(output_file)

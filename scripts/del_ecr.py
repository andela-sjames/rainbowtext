import os
import boto3

client = boto3.client('ecr')

# Get the name of the current directory
PROJECT_NAME = os.path.basename(os.path.realpath("."))

AWS_ACCOUNT_ID = os.getenv('AWS_ACCOUNT_ID', 'your_AWS_id')
AWS_REGION = os.getenv('AWS_REGION', 'your_aws_region')

# use if repository exist
SERVER_REPOSITORY_URI = f'{AWS_ACCOUNT_ID}.dkr.ecr.{AWS_REGION}.amazonaws.com/{PROJECT_NAME}_server'
NGINX_REPOSITORY_URI = f'{AWS_ACCOUNT_ID}.dkr.ecr.{AWS_REGION}.amazonaws.com/{PROJECT_NAME}_nginx'

ECR_REPO_OBJ = {
    f"{PROJECT_NAME}_server": SERVER_REPOSITORY_URI,
    f"{PROJECT_NAME}_nginx": NGINX_REPOSITORY_URI
}

for key, value in ECR_REPO_OBJ.items():
    response = client.delete_repository(
        registryId=AWS_ACCOUNT_ID,
        repositoryName=key,
        force=True
    )

    print(response)

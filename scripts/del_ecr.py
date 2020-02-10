import os
import boto3

client = boto3.client('ecr')

ID = os.getenv('AWS_ACCOUNT_ID', 'your_AWS_id')
REGION = os.getenv('AWS_REGION', 'your_aws_region')
PROJECT = os.getenv('AWS_PROJECT', 'your_aws_region')

# use if repository exist
SERVER_REPOSITORY_URI = f'{ID}.dkr.ecr.{REGION}.amazonaws.com/{PROJECT}_server'
NGINX_REPOSITORY_URI = f'{ID}.dkr.ecr.{REGION}.amazonaws.com/{PROJECT}_nginx'

ECR_REPO_OBJ = {
    f"{PROJECT}_server": SERVER_REPOSITORY_URI,
    f"{PROJECT}_nginx": NGINX_REPOSITORY_URI
}

for key, value in ECR_REPO_OBJ.items():
    response = client.delete_repository(
        registryId=ID,
        repositoryName=key,
        force=True
    )

    print(response)

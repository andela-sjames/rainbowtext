import subprocess


# configure aws 
# use shell in the meantime, might include a script later.

# retrieve the login command to use to authenticate your Docker client to your registry.
subprocess.Popen(["aws", "ecr", "get-login", "--no-include-email", "--region", "us-east-1"])

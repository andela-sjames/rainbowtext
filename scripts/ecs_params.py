import os
import subprocess
import sys
import time
import yaml
import re

alt_input = "ecs-params.yml"
alt_output = "ecs-params.ecs.yml"

input_file = os.environ.get("ECS_PARAMS_INPUT", alt_input)
output_file = os.environ.get("ECS_PARAMS_OUTPUT", alt_output)

params = sys.argv

vpc_id = params[1]
security_group = params[2]
subnet_a = params[3]
subnet_b = params[4]

stack = yaml.safe_load(open(input_file))
services = stack["run_params"]["network_configuration"]

services["awsvpc_configuration"]["subnets"] = [subnet_a, subnet_b]
services["awsvpc_configuration"]["security_groups"] = [security_group]


with open(output_file, "w") as out_file:
    yaml.dump(stack, out_file, default_flow_style=False)

# yaml that is produced is a bit buggy.
fh = open(output_file, "r+")
lines = map(lambda a: re.sub(r"^\s{4}-", "      -", a), fh.readlines())
fh.close()
with open(output_file, "w") as f:
    f.writelines(lines)
from jsonschema import validate
import json
import yaml
import os

#Load Schema
with open('schema.json') as file:
    schema = json.load(file)

#Test ingress file
if os.path.exists("../ingressPolicies.yml"):
    with open('../ingressPolicies.yml') as ingress_file:
        ingress_yml = yaml.load(ingress_file, Loader=yaml.FullLoader)
        validate(instance=ingress_yml, schema=schema)
        print("VALID")
            

#Test egress file
if os.path.exists("../egressPolicies.yml"):
    with open('../egressPolicies.yml') as ingress_file:
        ingress_yml = yaml.load(ingress_file, Loader=yaml.FullLoader)
        validate(instance=ingress_yml, schema=schema)
        print("VALID")
        

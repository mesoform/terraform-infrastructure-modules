from sys import path, stderr

try:
    path.insert(1, '../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, stderr)

"""
    Tests whether key values appear in an ingress policy yaml file. File takes the structure:
    
    ```
        - ingressFrom:
            identityType: ANY_IDENTITY
            sources:
              - accessLevel: accessPolicies/000000000000000000/accessLevels/example
              - accessLevel: accessPolicies/000000000000000000/accessLevels/example2
            ingressTo:
              operations:
                - serviceName: '*'
               resources:
                - '*'
    ```
"""

expected_data = {
    "identity-type": "ANY_IDENTITY",
    "source-one": "accessPolicies/000000000000000000/accessLevels/example"
}



if __name__ == '__main__':
    python_validator(expected_data)

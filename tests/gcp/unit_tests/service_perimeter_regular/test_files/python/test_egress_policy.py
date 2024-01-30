from sys import path, stderr

try:
    path.insert(1, '../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, stderr)

"""
    Tests whether key values appear in an ingress policy yaml file. File takes the structure:
    
    ```
        egressPolicies:
          - egressFrom:
              identityType: ANY_IDENTITY
            egressTo:
              operations:
                - serviceName: compute.googleapis.com
                  methodSelectors:
                    - method: '*'
              resources:
                - projects/000000000000
    ```
"""

expected_data = {
    "identity-type": "ANY_IDENTITY",
    "method": "*",
    "resource": "projects/000000000000",
    "serviceName": "compute.googleapis.com"
}



if __name__ == '__main__':
    python_validator(expected_data)

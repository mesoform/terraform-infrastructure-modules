# Regular Service Perimter

Describes a set of GCP resources which can import and export data amongst themselves.

Note: Regular service perimeters cannot overlap as a single GCP project can only belong to one regular service perimeter

Example usage:
```hcl
module access_manager {
  source = "github.com/mesoform/terraform-infrastructure-modules//gcp/access_context_manager/service_perimeter_regular"
  name = "example"
  access_polcies_name = "000000000000000"
  ingress_file_path = "/somePath/ingressPolicies.yml"
  egress_file_path = "/somePath/egressPolicies.yml"
}
```

### VPC Accessible Services

The `vpc_accessible_services` block defines the services which can be accessed from a network within the perimeter.
There are 4 options available for vpc accessible sevices configuration
* All APIs available - Setting VPC accessible services to `'ALL-SERVICES'` will set `enable_restiction` to false. Configuration shown below:
  ```hcl
    vpc_accessible_services = ["ALL-SERVICES"]
  ```
* Restricted Services (Default) - Using the Enum `'RESTRICTED-SERVICES'` VPC accessible services will be enabled and the allowed services will match whatever `restricted_services` is, 
  i.e., any services restricted by the perimeter.  
  Ommitting `vpc_accessible_services` from configuration will default to this option. The following configuration produces the same result:
  ```hcl
    vpc_accessible_services = null  
  ```
  or 
  ```hcl
    vpc_accessible_services = ["RESTRICTED-SERVICES"]
  ```
* No-services allowed - This configuration sets `enabled_restrition` to `true` but has no services in `allowed_services`. Configuration:
  ```hcl
    vpc_accessible_services = []
  ```
* Specified services allowed - This will set `enabled_restriction` to `true` and allow the specified APIs. Configuration:
  ```hcl 
    vpc_accessible_services = ["compute.googleapis.com", "storage.googleapis.com"]
  ```

### Ingress/Egress Policies
Ingress and egress rules allow access to and from the resources and clients protected by service perimeters.

To configure a path to a YAML file containing the ingress/egress configuration should be set in `ingress_file_path`/`egress_file_path`. 
The default paths for searching for ingress/egress configuration are `"./ingress_policies,yml"` and `"./egress_policies,yml"`.
Structure of these files can be found in the [ingress rules](https://cloud.google.com/vpc-service-controls/docs/ingress-egress-rules#ingress_rules_reference) 
and the [egress rules](https://cloud.google.com/vpc-service-controls/docs/ingress-egress-rules#egress_rules_reference) documentation.

Example ingress_policies.yml:
```yaml
  ingressPolicies:
  - ingressFrom:
      identityType: ANY_IDENTITY
      sources:
      - accessLevel: accessPolicies/0000000000/accessLevels/level1
      - accessLevel: accessPolicies/0000000000/accessLevels/level2
    ingressTo:
      operations:
      - serviceName: '*'
      resources:
      - '*'
```

Example egress_policies.yml:
```yml
  egressPolicies:
  - egressFrom:
      identities:
      - serviceAccount:account@project.iam.gserviceaccount.com
    egressTo:
      operations:
      - methodSelectors:
        - method: '*'
        serviceName: compute.googleapis.com
      resources:
      - '*'
```

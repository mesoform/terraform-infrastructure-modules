# Global HTTP Load Balancer Terraform Module for Cloud Run Serverless NEGs

This submodule allows you to create Cloud HTTP(S) Load Balancer with Serverless Network Endpoint Groups (NEGs) and place serverless services from Cloud Run behind a Cloud Load Balancer.

## Example usage

```HCL
module cloudrun_serverless_neg_https_lb {
  source = "github.com/mesoform/terraform-infrastructure-modules//gcp/compute_engine/cloudrun_serverless_neg_https_lb"
  project = "test-project"
  region = "europe-west2"
  serverless_neg_name = "cr-serverless-neg"
  cloudrun_service_name = "cloudrun-service"
  serverless_https_lb_name = "test-project-lb"
  serverless_https_lb_http_forward = false
  serverless_https_lb_ssl = true
  managed_ssl_certificate_domains = ["test-project-domain.com"]
  serverless_https_lb_backends = {
    cloudrun = {
      description = "Cloud Run backend"
      security_policy = "cloudrun-policy"
      groups = [
        {
          group = projects/test-project/regions/europe-west2/networkEndpointGroups/cr-serverless-neg
        }
      ]
      iap_config = {
        enable = false
      }      
      log_config = {
        enable = false
      }
    }
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name                               | Description                                                                                             | Type                                                                                                                                                                                                                                                                                                                                           | Default | Required |
|------------------------------------|---------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------|:--------:|
| project                            | The project to deploy to.                                                                               | `string`                                                                                                                                                                                                                                                                                                                                       | n/a     |   yes    |
| region                             | Location for serverless_neg and load balancer.                                                          | `string`                                                                                                                                                                                                                                                                                                                                       | n/a     |   yes    |
| serverless_neg_name                | Name for serverless network endpoint group.                                                             | `string`                                                                                                                                                                                                                                                                                                                                       | n/a     |   yes    |
| cloudrun_service_name              | Name for an existing Cloud run service.                                                                 | `string`                                                                                                                                                                                                                                                                                                                                       | n/a     |   yes    |
| serverless_https_lb_name           | Name for the forwarding rule and prefix for supporting resources.                                       | `string`                                                                                                                                                                                                                                                                                                                                       | n/a     |   yes    |
| serverless_https_lb_http_forward   | Whether to create a forwarding rule for HTTP traffic.                                                   | `bool`                                                                                                                                                                                                                                                                                                                                         | `false` |    no    |
| managed\_ssl\_certificate\_domains | Create Google-managed SSL certificates for specified domains. Requires `ssl` to be set to `true`.       | `list(string)`                                                                                                                                                                                                                                                                                                                                 | n/a     |   yes    |
| serverless_https_lb_backends       | Map backend indices to list of backend maps.                                                            | <pre>map(object({<br><br>    description             = string<br>    security_policy         = string<br><br>    groups = list(object({<br>      group = string<br><br>    }))<br>    iap_config = object({<br>      enable      = bool<br>    })<br>  }))<br>    log_config = object({<br>      enable      = bool<br>    })<br>  }))</pre>   | n/a     |   yes    |

### _serverless_https_lb_backends_ type structure:
- description: (Optional) Description of the resource.
- security_policy: (Required) The security policy associated with this backend service. 
- group: (Required) The fully-qualified URL of an Instance Group or Network Endpoint Group resource. In case of instance group this defines the list of instances that serve traffic. Member virtual machine instances from each instance group must live in the same zone as the instance group itself. No two backends in a backend service are allowed to use same Instance Group resource. For Network Endpoint Groups this defines list of endpoints. All endpoints of Network Endpoint Group must be hosted on instances located in the same zone as the Network Endpoint Group. Backend services cannot mix Instance Group and Network Endpoint Group backends. Note that you must specify an Instance Group or Network Endpoint Group resource using the fully-qualified URL, rather than a partial URL.
- iap_config: 
  - enable: (Optional) Whether to enable Cloud Identity Aware Proxy.
- log_config:
  - enable: (Optional) Whether to enable logging for the load balancer traffic served by this backend service. If logging is enabled, logs will be exported to Stackdriver.


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

# Global HTTP Load Balancer Terraform Module for Serverless NEGs

This submodule allows you to create Cloud HTTP(S) Load Balancer with Serverless Network Endpoint Groups (NEGs) and place serverless services behind a Cloud Load Balancer.

## Example usage

```HCL
module serverless_neg_https_lb {
  source = "github.com/mesoform/terraform-infrastructure-modules//gcp/compute_engine/cloudrun_serverless_neg_https_lb"
  project = "test-project"
  serverless_neg_name = "serverless-neg"
  serverless_https_lb_name = "test-project-lb"
  managed_ssl_certificate_domains = ["test-project-domain.com"]
  cloud_functions = [
    { function_name = "cloudfunction-test1", region = "europe-west2" }
  ]  
  cloud_run_services = [
    { service_name = "cloudrun-test1", region = "europe-west1" },
    { service_name = "cloudrun-test2", region = "europe-west2" }
  ]
  security_policy = "cryptotraders-cloudrun-policy"
  enable_iap_config = false
  enable_log_config = false
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name                               | Description                                                       | Type                                                                                   | Default | Required |
|------------------------------------|-------------------------------------------------------------------|----------------------------------------------------------------------------------------|---------|:--------:|
| project                            | The project to deploy to.                                         | `string`                                                                               | n/a     |   yes    |
| serverless_neg_name                | Name for serverless network endpoint group.                       | `string`                                                                               | n/a     |   yes    |
| serverless_https_lb_name           | Name for the forwarding rule and prefix for supporting resources. | `string`                                                                               | n/a     |   yes    |
| managed\_ssl\_certificate\_domains | Create Google-managed SSL certificates for specified domains.     | `list(string)`                                                                         | n/a     |   yes    |
| app_engine_services                | List of app engine services for load balancer backend.            | <pre>list(object({<br>    service name = string<br>    region = string<br>  }))</pre>  | []      |    no    |
| cloud_functions                    | List of cloud functions for load balancer backend.                | <pre>list(object({<br>    function name = string<br>    region = string<br>  }))</pre> | []      |    no    |
| cloud_run_services                 | List of cloud run services for load balancer backend.             | <pre>list(object({<br>    service name = string<br>    region = string<br>  }))</pre>  | []      |    no    |
| security_policy                    | The security policy associated with this backend services.        | `string`                                                                               | n/a     |   yes    |
| enable_iap_config                  | Whether to enable Cloud Identity Aware Proxy.                     | `string`                                                                               | false   |    no    |
| enable_log_config                  | Whehter to enable logging.                                        | `string`                                                                               | false   |    no    |

### Post deployment steps:
- Load balancer backend default:
By default all traffic will be sent to first backend (either app_engine, cloud_function or cloud_run).
Check load balancer configuration and edit backends to use the appropriate one.
- The backends protocol is set to HTTP by default. To update the protocol to HTTPS the following command needs to be run on each one:
```
gcloud compute backend-services list
gcloud compute backend-services update <backend-service-name> --protocol HTTPS --global
```

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

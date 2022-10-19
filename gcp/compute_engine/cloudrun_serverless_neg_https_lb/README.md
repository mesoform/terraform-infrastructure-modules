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
  name = "test-project-lb"
  ssl = true
  managed_ssl_certificate_domains = ["test-project-domain.com"]
  backends = {
    cloudrun = {
      description = "Cloud Run backend"
      groups = [
        {
          group = projects/test-project/regions/europe-west2/networkEndpointGroups/cr-serverless-neg
        }
      ]
      security_policy = "cloudrun-policy"      
      log_config = {
        enable = true
        sample_rate = 1.0
      }
    }
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name                               | Description                                                                                                                                 | Type                                                                                                                                                                                                                                                                                           | Default | Required |
|------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------|:--------:|
| project                            | The project to deploy to.                                                                                                                   | `string`                                                                                                                                                                                                                                                                                       | n/a     |   yes    |
| region                             | Location for serverless_neg and load balancer.                                                                                              | `string`                                                                                                                                                                                                                                                                                       | n/a     |   yes    |
| serverless_neg_name                | Name for serverless network endpoint group.                                                                                                 | `string`                                                                                                                                                                                                                                                                                       | n/a     |   yes    |
| cloudrun_service_name              | Name for an existing Cloud run service.                                                                                                     | `string`                                                                                                                                                                                                                                                                                       | n/a     |   yes    |
| name                               | Name for the forwarding rule and prefix for supporting resources                                                                            | `string`                                                                                                                                                                                                                                                                                       | n/a     |   yes    |
| address                            | Existing IPv4 address to use (the actual IP address value)                                                                                  | `string`                                                                                                                                                                                                                                                                                       | `null`  |   no     |
| backends                           | Map backend indices to list of backend maps.                                                                                                | <pre>map(object({<br><br>    description             = string<br>    security_policy         = string<br><br>    groups = list(object({<br>      group = string<br><br>    }))<br>    log_config = object({<br>      enable      = bool<br>      sample_rate = number<br>    })<br>  }))</pre> | n/a     |   yes    |
| certificate                        | Content of the SSL certificate. Required if `ssl` is `true` and `ssl_certificates` is empty.                                                | `string`                                                                                                                                                                                                                                                                                       | `null`  |    no    |
| create\_address                    | Create a new global IPv4 address                                                                                                            | `bool`                                                                                                                                                                                                                                                                                         | `true`  |    no    |
| create\_ipv6\_address              | Allocate a new IPv6 address. Conflicts with "ipv6\_address" - if both specified, "create\_ipv6\_address" takes precedence.                  | `bool`                                                                                                                                                                                                                                                                                         | `false` |    no    |
| create\_url\_map                   | Set to `false` if url\_map variable is provided.                                                                                            | `bool`                                                                                                                                                                                                                                                                                         | `true`  |    no    |
| enable\_ipv6                       | Enable IPv6 address on the CDN load-balancer                                                                                                | `bool`                                                                                                                                                                                                                                                                                         | `false` |    no    |
| ipv6\_address                      | An existing IPv6 address to use (the actual IP address value)                                                                               | `string`                                                                                                                                                                                                                                                                                       | `null`  |    no    |
| managed\_ssl\_certificate\_domains | Create Google-managed SSL certificates for specified domains. Requires `ssl` to be set to `true` and `use_ssl_certificates` set to `false`. | `list(string)`                                                                                                                                                                                                                                                                                 | `[]`    |    no    |
| private\_key                       | Content of the private SSL key. Required if `ssl` is `true` and `ssl_certificates` is empty.                                                | `string`                                                                                                                                                                                                                                                                                       | `null`  |    no    |
| security\_policy                   | The resource URL for the security policy to associate with the backend service                                                              | `string`                                                                                                                                                                                                                                                                                       | `null`  |    no    |
| ssl                                | Set to `true` to enable SSL support, requires variable `ssl_certificates` - a list of self\_link certs                                      | `bool`                                                                                                                                                                                                                                                                                         | `false` |    no    |
| ssl\_certificates                  | SSL cert self\_link list. Required if `ssl` is `true` and no `private_key` and `certificate` is provided.                                   | `list(string)`                                                                                                                                                                                                                                                                                 | `[]`    |    no    |
| url\_map                           | The url\_map resource to use. Default is to send all traffic to first backend.                                                              | `string`                                                                                                                                                                                                                                                                                       | `null`  |    no    |
| use\_ssl\_certificates             | If true, use the certificates provided by `ssl_certificates`, otherwise, create cert from `private_key` and `certificate`                   | `bool`                                                                                                                                                                                                                                                                                         | `false` |    no    |

## Outputs

| Name | Description |
|------|-------------|
| external\_ip | The external IPv4 assigned to the global fowarding rule. |
| https\_proxy | The HTTPS proxy used by this module. |
| url\_map | The default URL map used by this module. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

* [`google_compute_global_forwarding_rule.https`](https://www.terraform.io/docs/providers/google/r/compute_global_forwarding_rule.html): The global HTTPS forwarding rule created when `ssl` is `true`.
* [`google_compute_target_https_proxy.default`](https://www.terraform.io/docs/providers/google/r/compute_target_https_proxy.html): The HTTPS proxy resource that binds the url map. Created when input `ssl` is `true`.
* [`google_compute_ssl_certificate.default`](https://www.terraform.io/docs/providers/google/r/compute_ssl_certificate.html): The certificate resource created when input `ssl` is `true` and `managed_ssl_certificate_domains` not specified.
* [`google_compute_managed_ssl_certificate.default`](https://www.terraform.io/docs/providers/google/r/compute_managed_ssl_certificate.html): The Google-managed certificate resource created when input `ssl` is `true` and `managed_ssl_certificate_domains` is specified.
* [`google_compute_url_map.default`](https://www.terraform.io/docs/providers/google/r/compute_url_map.html): The default URL map resource when input `url_map` is not provided.
* [`google_compute_backend_service.default.*`](https://www.terraform.io/docs/providers/google/r/compute_backend_service.html): The backend services created for each of the `backend_params` elements.
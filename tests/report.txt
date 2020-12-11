✘ dmitrogavrichuk@iMac-Dmitro  ~/DEVOPS/Mesoform/volume_test/k8s_adapter/cluster  clear
dmitrogavrichuk@iMac-Dmitro  ~/DEVOPS/Mesoform/volume_test/k8s_adapter/cluster  gcloud config set project global
-cluster-2
Updated property [core/project].
dmitrogavrichuk@iMac-Dmitro  ~/DEVOPS/Mesoform/volume_test/k8s_adapter/cluster  gcloud services enable container.googleapis.com
Operation "operations/acf.30f33d49-0971-482b-a8be-3ec82fb5a603" finished successfully.
dmitrogavrichuk@iMac-Dmitro  ~/DEVOPS/Mesoform/volume_test/k8s_adapter/cluster  terraform apply
google_compute_network.vpc: Refreshing state... [id=projects/global-cluster/global/networks/global-cluster-vpc]
google_compute_subnetwork.subnet: Refreshing state... [id=projects/global-cluster/regions/europe-west2/subnetworks/global-cluster-subnet]
google_container_cluster.primary: Refreshing state... [id=projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke]
google_container_node_pool.primary_nodes: Refreshing state... [id=projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke/nodePools/global-cluster-gke-node-pool]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
-/+ destroy and then create replacement

Terraform will perform the following actions:

 # google_compute_network.vpc must be replaced
-/+ resource "google_compute_network" "vpc" {
       auto_create_subnetworks         = false
       delete_default_routes_on_create = false
     + gateway_ipv4                    = (known after apply)
     ~ id                              = "projects/global-cluster/global/networks/global-cluster-vpc" -> (known after apply)
     ~ mtu                             = 0 -> (known after apply)
     ~ name                            = "global-cluster-vpc" -> "global-cluster-2-vpc" # forces replacement
     ~ project                         = "global-cluster" -> (known after apply)
     ~ routing_mode                    = "REGIONAL" -> (known after apply)
     ~ self_link                       = "https://www.googleapis.com/compute/v1/projects/global-cluster/global/networks/global-cluster-vpc" -> (known after apply)
   }

 # google_compute_subnetwork.subnet must be replaced
-/+ resource "google_compute_subnetwork" "subnet" {
     ~ creation_timestamp         = "2020-12-02T02:50:26.924-08:00" -> (known after apply)
     + fingerprint                = (known after apply)
     ~ gateway_address            = "10.10.0.1" -> (known after apply)
     ~ id                         = "projects/global-cluster/regions/europe-west2/subnetworks/global-cluster-subnet" -> (known after apply)
       ip_cidr_range              = "10.10.0.0/24"
     ~ name                       = "global-cluster-subnet" -> "global-cluster-2-subnet" # forces replacement
     ~ network                    = "https://www.googleapis.com/compute/v1/projects/global-cluster/global/networks/global-cluster-vpc" -> "global-cluster-2-vpc" # forces replacement
     - private_ip_google_access   = false -> null
     ~ private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS" -> (known after apply)
     ~ project                    = "global-cluster" -> (known after apply)
       region                     = "europe-west2"
     ~ secondary_ip_range         = [] -> (known after apply)
     ~ self_link                  = "https://www.googleapis.com/compute/v1/projects/global-cluster/regions/europe-west2/subnetworks/global-cluster-subnet" -> (known after apply)
   }

 # google_container_cluster.primary must be replaced
-/+ resource "google_container_cluster" "primary" {
     ~ cluster_ipv4_cidr           = "10.184.0.0/14" -> (known after apply)
     + default_max_pods_per_node   = (known after apply)
       enable_binary_authorization = false
       enable_kubernetes_alpha     = false
       enable_legacy_abac          = false
       enable_shielded_nodes       = false
     ~ endpoint                    = "34.105.174.45" -> (known after apply)
     ~ id                          = "projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke" -> (known after apply)
       initial_node_count          = 1
     ~ instance_group_urls         = [
         - "https://www.googleapis.com/compute/v1/projects/global-cluster/zones/europe-west2-a/instanceGroups/gke-global-cluster-g-global-cluster-g-452b0aa5-grp",
         - "https://www.googleapis.com/compute/v1/projects/global-cluster/zones/europe-west2-c/instanceGroups/gke-global-cluster-g-global-cluster-g-fe11a29d-grp",
         - "https://www.googleapis.com/compute/v1/projects/global-cluster/zones/europe-west2-b/instanceGroups/gke-global-cluster-g-global-cluster-g-2a267059-grp",
       ] -> (known after apply)
     ~ label_fingerprint           = "a9dc16a7" -> (known after apply)
       location                    = "europe-west2"
     ~ logging_service             = "logging.googleapis.com/kubernetes" -> (known after apply)
     ~ master_version              = "1.16.13-gke.401" -> (known after apply)
     ~ monitoring_service          = "monitoring.googleapis.com/kubernetes" -> (known after apply)
     ~ name                        = "global-cluster-gke" -> "global-cluster-2-gke" # forces replacement
     ~ network                     = "projects/global-cluster/global/networks/global-cluster-vpc" -> "global-cluster-2-vpc" # forces replacement
     ~ node_locations              = [
         - "europe-west2-a",
         - "europe-west2-b",
         - "europe-west2-c",
       ] -> (known after apply)
     ~ node_version                = "1.16.13-gke.401" -> (known after apply)
     + operation                   = (known after apply)
     ~ project                     = "global-cluster" -> (known after apply)
       remove_default_node_pool    = true
     - resource_labels             = {} -> null
     ~ self_link                   = "https://container.googleapis.com/v1beta1/projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke" -> (known after apply)
     ~ services_ipv4_cidr          = "10.187.240.0/20" -> (known after apply)
     ~ subnetwork                  = "projects/global-cluster/regions/europe-west2/subnetworks/global-cluster-subnet" -> "global-cluster-2-subnet" # forces replacement

     ~ addons_config {
         + cloudrun_config {
             + disabled           = (known after apply)
             + load_balancer_type = (known after apply)
           }

         + horizontal_pod_autoscaling {
             + disabled = (known after apply)
           }

         + http_load_balancing {
             + disabled = (known after apply)
           }

         ~ network_policy_config {
             ~ disabled = true -> (known after apply)
           }
       }

     + authenticator_groups_config {
         + security_group = (known after apply)
       }

     ~ cluster_autoscaling {
         ~ enabled = false -> (known after apply)

         + auto_provisioning_defaults {
             + oauth_scopes    = (known after apply)
             + service_account = (known after apply)
           }

         + resource_limits {
             + maximum       = (known after apply)
             + minimum       = (known after apply)
             + resource_type = (known after apply)
           }
       }

     ~ database_encryption {
         + key_name = (known after apply)
         ~ state    = "DECRYPTED" -> (known after apply)
       }

     ~ master_auth {
         + client_certificate     = (known after apply)
         + client_key             = (sensitive value)
         ~ cluster_ca_certificate = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURLekNDQWhPZ0F3SUJBZ0lSQVB3cHdKWnIwYWpsbUFMUjRJNGpaYVF3RFFZSktvWklodmNOQVFFTEJRQXcKTHpFdE1Dc0dBMVVFQXhNa05XRTNORGc0WWpBdE1EUTJZeTAwWkRjMExUZ3hNVE10TldNNU56Vm1NR1JqWTJFMQpNQjRYRFRJd01USXdNakE1TlRBek9Wb1hEVEkxTVRJd01URXdOVEF6T1Zvd0x6RXRNQ3NHQTFVRUF4TWtOV0UzCk5EZzRZakF0TURRMll5MDBaRGMwTFRneE1UTXROV001TnpWbU1HUmpZMkUxTUlJQklqQU5CZ2txaGtpRzl3MEIKQVFFRkFBT0NBUThBTUlJQkNnS0NBUUVBeHhuU0ppczVsRzhOUFF3N1J1K1pTSHlLczNRV0N1Q2U0OWxtdExRegpKdUdDeTl0T3dvMTFCdjJxblA2RS9JMERsdzc2eTcwaU5iYzJ0L3NzdkQxTTZwU0IxOHFXbXJqUHNkaDRBNEhzCmNaUW1yZVpsbXBOSTU2c1ZHb1dxMXlZSlErNjlkOG55cDUvQnJqSlZtS0FGRzJPRkVWMTlJcnFLRE1JREJ2VU4KL3VKZ0RpNEVtcTFtYllYS0JsNWVHSW1JWkl1d3BPNGhVSFdHbkJOb0dNVlMrRkx6aW8zSFlYbkZHMmtMWFN1ZApDcm00S0FEZElQQitZVzJkTVpmVTgyWWRaa0QwaWx2Z3BVSHJibzhEd2dxSjByQVNNRm9oaXpsdm81aXNSWlhHClZ4azBuT0s1RW1JS0ozOTR2ZzdLT1ZidHkyTmZITnZOU1VQdWFyU3laeXVzOHdJREFRQUJvMEl3UURBT0JnTlYKSFE4QkFmOEVCQU1DQWdRd0R3WURWUjBUQVFIL0JBVXdBd0VCL3pBZEJnTlZIUTRFRmdRVWlOSFhFelJqWnEwRApGR1hpTldER0dmUG1MUFF3RFFZSktvWklodmNOQVFFTEJRQURnZ0VCQUJ4VWlzN0hIZVZvdzhhekhGUkZjYTVRCnM2ME1BZEJDZ3lvS3pWUy9hL1EwWmVoSno1ZjJvUjl5c1pwK1dtazJBVWYycWhPQ2J0VE1idWs5MCtOV01IUnUKZWtCR1kzMGdSclpSL2pBQTZLb1IycnIrYUU3YXNRdnJqY3FoOWlSR2RUdnlRaW1QbmdUL21qcy80c2Z0Zm01UwpwOGV0aGJvZWYzamNlazdJbnphYUg5aHBWR2RHREU1RUlpTUZreE9jNm4rL0hhWGNVa1Yyd0d3R2VSZmZuVjRMCjdaZkt0bTdRclJPMzFIMXZZRE1vTG1LOE4zbjQ0SjZ0VXRUUkJrTVlvY0xEaHNHWXVsN1drUlRUaitiWDRVRnIKNk9mU3MrdlRSVHNheEMrVUlkVHpSNzF4THE1QmhodzRtT2ZzSjkxRHZyTlR3bDU1NlF6RURUSGVubVZGM2NvPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==" -> (known after apply)

           client_certificate_config {
               issue_client_certificate = false
           }
       }

     ~ network_policy {
         ~ enabled  = false -> (known after apply)
         ~ provider = "PROVIDER_UNSPECIFIED" -> (known after apply)
       }

     ~ node_config {
         ~ disk_size_gb      = 100 -> (known after apply)
         ~ disk_type         = "pd-standard" -> (known after apply)
         ~ guest_accelerator = [] -> (known after apply)
         ~ image_type        = "COS" -> (known after apply)
         ~ labels            = {
             - "env" = "global-cluster"
           } -> (known after apply)
         ~ local_ssd_count   = 0 -> (known after apply)
         ~ machine_type      = "n1-standard-4" -> (known after apply)
         ~ metadata          = {
             - "disable-legacy-endpoints" = "true"
           } -> (known after apply)
         + min_cpu_platform  = (known after apply)
         ~ oauth_scopes      = [
             - "https://www.googleapis.com/auth/logging.write",
             - "https://www.googleapis.com/auth/monitoring",
           ] -> (known after apply)
         ~ preemptible       = false -> (known after apply)
         ~ service_account   = "default" -> (known after apply)
         ~ tags              = [
             - "gke-node",
             - "global-cluster-gke",
           ] -> (known after apply)
         ~ taint             = [] -> (known after apply)

         ~ shielded_instance_config {
             ~ enable_integrity_monitoring = true -> (known after apply)
             ~ enable_secure_boot          = false -> (known after apply)
           }

         + workload_metadata_config {
             + node_metadata = (known after apply)
           }
       }

     ~ node_pool {
         ~ initial_node_count  = 1 -> (known after apply)
         ~ instance_group_urls = [
             - "https://www.googleapis.com/compute/v1/projects/global-cluster/zones/europe-west2-a/instanceGroupManagers/gke-global-cluster-g-global-cluster-g-452b0aa5-grp",
             - "https://www.googleapis.com/compute/v1/projects/global-cluster/zones/europe-west2-c/instanceGroupManagers/gke-global-cluster-g-global-cluster-g-fe11a29d-grp",
             - "https://www.googleapis.com/compute/v1/projects/global-cluster/zones/europe-west2-b/instanceGroupManagers/gke-global-cluster-g-global-cluster-g-2a267059-grp",
           ] -> (known after apply)
         ~ max_pods_per_node   = 0 -> (known after apply)
         ~ name                = "global-cluster-gke-node-pool" -> (known after apply)
         + name_prefix         = (known after apply)
         ~ node_count          = 1 -> (known after apply)
         ~ node_locations      = [
             - "europe-west2-a",
             - "europe-west2-b",
             - "europe-west2-c",
           ] -> (known after apply)
         ~ version             = "1.16.13-gke.401" -> (known after apply)

         + autoscaling {
             + max_node_count = (known after apply)
             + min_node_count = (known after apply)
           }

         ~ management {
             ~ auto_repair  = true -> (known after apply)
             ~ auto_upgrade = true -> (known after apply)
           }

         ~ node_config {
             ~ disk_size_gb      = 100 -> (known after apply)
             ~ disk_type         = "pd-standard" -> (known after apply)
             ~ guest_accelerator = [] -> (known after apply)
             ~ image_type        = "COS" -> (known after apply)
             ~ labels            = {
                 - "env" = "global-cluster"
               } -> (known after apply)
             ~ local_ssd_count   = 0 -> (known after apply)
             ~ machine_type      = "n1-standard-4" -> (known after apply)
             ~ metadata          = {
                 - "disable-legacy-endpoints" = "true"
               } -> (known after apply)
             + min_cpu_platform  = (known after apply)
             ~ oauth_scopes      = [
                 - "https://www.googleapis.com/auth/logging.write",
                 - "https://www.googleapis.com/auth/monitoring",
               ] -> (known after apply)
             ~ preemptible       = false -> (known after apply)
             ~ service_account   = "default" -> (known after apply)
             ~ tags              = [
                 - "gke-node",
                 - "global-cluster-gke",
               ] -> (known after apply)
             ~ taint             = [] -> (known after apply)

             ~ shielded_instance_config {
                 ~ enable_integrity_monitoring = true -> (known after apply)
                 ~ enable_secure_boot          = false -> (known after apply)
               }

             + workload_metadata_config {
                 + node_metadata = (known after apply)
               }
           }

         ~ upgrade_settings {
             ~ max_surge       = 1 -> (known after apply)
             ~ max_unavailable = 0 -> (known after apply)
           }
       }

     ~ release_channel {
         ~ channel = "UNSPECIFIED" -> (known after apply)
       }
   }

 # google_container_node_pool.primary_nodes must be replaced
-/+ resource "google_container_node_pool" "primary_nodes" {
     ~ cluster             = "global-cluster-gke" -> "global-cluster-2-gke" # forces replacement
     ~ id                  = "projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke/nodePools/global-cluster-gke-node-pool" -> (known after apply)
     ~ initial_node_count  = 1 -> (known after apply)
     ~ instance_group_urls = [
         - "https://www.googleapis.com/compute/v1/projects/global-cluster/zones/europe-west2-a/instanceGroupManagers/gke-global-cluster-g-global-cluster-g-452b0aa5-grp",
         - "https://www.googleapis.com/compute/v1/projects/global-cluster/zones/europe-west2-c/instanceGroupManagers/gke-global-cluster-g-global-cluster-g-fe11a29d-grp",
         - "https://www.googleapis.com/compute/v1/projects/global-cluster/zones/europe-west2-b/instanceGroupManagers/gke-global-cluster-g-global-cluster-g-2a267059-grp",
       ] -> (known after apply)
       location            = "europe-west2"
     + max_pods_per_node   = (known after apply)
     ~ name                = "global-cluster-gke-node-pool" -> "global-cluster-2-gke-node-pool" # forces replacement
     + name_prefix         = (known after apply)
       node_count          = 1
     ~ node_locations      = [
         - "europe-west2-a",
         - "europe-west2-b",
         - "europe-west2-c",
       ] -> (known after apply)
     ~ project             = "global-cluster" -> (known after apply)
     ~ version             = "1.16.13-gke.401" -> (known after apply)

     ~ management {
         ~ auto_repair  = true -> (known after apply)
         ~ auto_upgrade = true -> (known after apply)
       }

     ~ node_config {
         ~ disk_size_gb      = 100 -> (known after apply)
         ~ disk_type         = "pd-standard" -> (known after apply)
         ~ guest_accelerator = [] -> (known after apply)
         ~ image_type        = "COS" -> (known after apply)
         ~ labels            = { # forces replacement
             ~ "env" = "global-cluster" -> "global-cluster-2"
           }
         ~ local_ssd_count   = 0 -> (known after apply)
           machine_type      = "n1-standard-4"
           metadata          = {
               "disable-legacy-endpoints" = "true"
           }
           oauth_scopes      = [
               "https://www.googleapis.com/auth/logging.write",
               "https://www.googleapis.com/auth/monitoring",
           ]
           preemptible       = false
         ~ service_account   = "default" -> (known after apply)
         ~ tags              = [ # forces replacement
               "gke-node",
             - "global-cluster-gke",
             + "global-cluster-2-gke",
           ]
         ~ taint             = [] -> (known after apply)

         ~ shielded_instance_config {
             ~ enable_integrity_monitoring = true -> (known after apply)
             ~ enable_secure_boot          = false -> (known after apply)
           }

         + workload_metadata_config {
             + node_metadata = (known after apply)
           }
       }

     ~ upgrade_settings {
         ~ max_surge       = 1 -> (known after apply)
         ~ max_unavailable = 0 -> (known after apply)
       }
   }

Plan: 4 to add, 0 to change, 4 to destroy.

Changes to Outputs:
 ~ kubernetes_cluster_name = "global-cluster-gke" -> "global-cluster-2-gke"

Do you want to perform these actions?
 Terraform will perform the actions described above.
 Only 'yes' will be accepted to approve.

 Enter a value: yes

google_container_node_pool.primary_nodes: Destroying... [id=projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke/nodePools/global-cluster-gke-node-pool]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 10s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 20s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 30s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 40s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 50s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 1m0s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 1m10s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 1m20s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 1m30s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 1m40s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 1m50s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 2m0s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 2m10s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 2m20s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 2m30s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 2m40s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 2m50s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 3m0s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 3m10s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 3m20s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 3m30s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 3m40s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 3m50s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 4m0s elapsed]
google_container_node_pool.primary_nodes: Still destroying... [id=projects/global-cluster/locations/europ...nodePools/global-cluster-gke-node-pool, 4m10s elapsed]
google_container_node_pool.primary_nodes: Destruction complete after 4m17s
google_container_cluster.primary: Destroying... [id=projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke]
google_container_cluster.primary: Still destroying... [id=projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke, 10s elapsed]
google_container_cluster.primary: Still destroying... [id=projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke, 20s elapsed]
google_container_cluster.primary: Still destroying... [id=projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke, 30s elapsed]
google_container_cluster.primary: Still destroying... [id=projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke, 40s elapsed]
google_container_cluster.primary: Still destroying... [id=projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke, 50s elapsed]
google_container_cluster.primary: Still destroying... [id=projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke, 1m0s elapsed]
google_container_cluster.primary: Still destroying... [id=projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke, 1m10s elapsed]
google_container_cluster.primary: Still destroying... [id=projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke, 1m20s elapsed]
google_container_cluster.primary: Still destroying... [id=projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke, 1m30s elapsed]
google_container_cluster.primary: Still destroying... [id=projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke, 1m40s elapsed]
google_container_cluster.primary: Still destroying... [id=projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke, 1m50s elapsed]
google_container_cluster.primary: Still destroying... [id=projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke, 2m0s elapsed]
google_container_cluster.primary: Still destroying... [id=projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke, 2m10s elapsed]
google_container_cluster.primary: Still destroying... [id=projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke, 2m20s elapsed]
google_container_cluster.primary: Still destroying... [id=projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke, 2m30s elapsed]
google_container_cluster.primary: Still destroying... [id=projects/global-cluster/locations/europe-west2/clusters/global-cluster-gke, 2m40s elapsed]
google_container_cluster.primary: Destruction complete after 2m44s
google_compute_subnetwork.subnet: Destroying... [id=projects/global-cluster/regions/europe-west2/subnetworks/global-cluster-subnet]
google_compute_subnetwork.subnet: Still destroying... [id=projects/global-cluster/regions/europe-west2/subnetworks/global-cluster-subnet, 10s elapsed]
google_compute_subnetwork.subnet: Destruction complete after 12s
google_compute_network.vpc: Destroying... [id=projects/global-cluster/global/networks/global-cluster-vpc]
google_compute_network.vpc: Still destroying... [id=projects/global-cluster/global/networks/global-cluster-vpc, 10s elapsed]
google_compute_network.vpc: Destruction complete after 11s
google_compute_network.vpc: Creating...
google_compute_network.vpc: Still creating... [10s elapsed]
google_compute_network.vpc: Still creating... [20s elapsed]
google_compute_network.vpc: Creation complete after 23s [id=projects/global-cluster-2/global/networks/global-cluster-2-vpc]
google_compute_subnetwork.subnet: Creating...
google_compute_subnetwork.subnet: Still creating... [10s elapsed]
google_compute_subnetwork.subnet: Creation complete after 13s [id=projects/global-cluster-2/regions/europe-west2/subnetworks/global-cluster-2-subnet]
google_container_cluster.primary: Creating...
google_container_cluster.primary: Still creating... [10s elapsed]
google_container_cluster.primary: Still creating... [20s elapsed]
google_container_cluster.primary: Still creating... [30s elapsed]
google_container_cluster.primary: Still creating... [40s elapsed]
google_container_cluster.primary: Still creating... [50s elapsed]
google_container_cluster.primary: Still creating... [1m0s elapsed]
google_container_cluster.primary: Still creating... [1m10s elapsed]
google_container_cluster.primary: Still creating... [1m20s elapsed]
google_container_cluster.primary: Still creating... [1m30s elapsed]
google_container_cluster.primary: Still creating... [1m40s elapsed]
google_container_cluster.primary: Still creating... [1m50s elapsed]
google_container_cluster.primary: Still creating... [2m0s elapsed]
google_container_cluster.primary: Still creating... [2m10s elapsed]
google_container_cluster.primary: Still creating... [2m20s elapsed]
google_container_cluster.primary: Still creating... [2m30s elapsed]
google_container_cluster.primary: Still creating... [2m40s elapsed]
google_container_cluster.primary: Still creating... [2m50s elapsed]
google_container_cluster.primary: Still creating... [3m0s elapsed]
google_container_cluster.primary: Still creating... [3m10s elapsed]
google_container_cluster.primary: Still creating... [3m20s elapsed]
google_container_cluster.primary: Still creating... [3m30s elapsed]
google_container_cluster.primary: Still creating... [3m40s elapsed]
google_container_cluster.primary: Still creating... [3m50s elapsed]
google_container_cluster.primary: Still creating... [4m0s elapsed]
google_container_cluster.primary: Still creating... [4m10s elapsed]
google_container_cluster.primary: Still creating... [4m20s elapsed]
google_container_cluster.primary: Still creating... [4m30s elapsed]
google_container_cluster.primary: Still creating... [4m40s elapsed]
google_container_cluster.primary: Still creating... [4m50s elapsed]
google_container_cluster.primary: Still creating... [5m0s elapsed]
google_container_cluster.primary: Still creating... [5m10s elapsed]
google_container_cluster.primary: Still creating... [5m20s elapsed]
google_container_cluster.primary: Still creating... [5m30s elapsed]
google_container_cluster.primary: Still creating... [5m40s elapsed]
google_container_cluster.primary: Still creating... [5m50s elapsed]
google_container_cluster.primary: Still creating... [6m0s elapsed]
google_container_cluster.primary: Still creating... [6m10s elapsed]
google_container_cluster.primary: Creation complete after 6m13s [id=projects/global-cluster-2/locations/europe-west2/clusters/global-cluster-2-gke]
google_container_node_pool.primary_nodes: Creating...
google_container_node_pool.primary_nodes: Still creating... [10s elapsed]
google_container_node_pool.primary_nodes: Still creating... [20s elapsed]
google_container_node_pool.primary_nodes: Still creating... [30s elapsed]
google_container_node_pool.primary_nodes: Still creating... [40s elapsed]
google_container_node_pool.primary_nodes: Still creating... [50s elapsed]
google_container_node_pool.primary_nodes: Still creating... [1m0s elapsed]
google_container_node_pool.primary_nodes: Creation complete after 1m4s [id=projects/global-cluster-2/locations/europe-west2/clusters/global-cluster-2-gke/nodePools/global-cluster-2-gke-node-pool]

Apply complete! Resources: 4 added, 0 changed, 4 destroyed.

Outputs:

kubernetes_cluster_name = global-cluster-2-gke
region = europe-west2
dmitrogavrichuk@iMac-Dmitro  ~/DEVOPS/Mesoform/volume_test/k8s_adapter/cluster 
dmitrogavrichuk@iMac-Dmitro  ~/DEVOPS/Mesoform/volume_test/k8s_adapter/cluster  cd ../../../global_structure_test/app_1/build/helloworld
dmitrogavrichuk@iMac-Dmitro  ~/DEVOPS/Mesoform/global_structure_test/app_1/build/helloworld  sudo nano main.py
Password:
dmitrogavrichuk@iMac-Dmitro  ~/DEVOPS/Mesoform/global_structure_test/app_1/build/helloworld  gcloud builds submit --tag gcr.io/global-cluster-2/helloworld
Creating temporary tarball archive of 5 file(s) totalling 3.3 KiB before compression.
Uploading tarball of [.] to [gs://global-cluster-2_cloudbuild/source/1606921779.223939-e942fb1fbfb744589a405578d78a3d25.tgz]
API [cloudbuild.googleapis.com] not enabled on project [115011585027].
Would you like to enable and retry (this will take a few minutes)?
(y/N)?  y

Enabling service [cloudbuild.googleapis.com] on project [115011585027]...
Operation "operations/acf.38ee9d12-d026-4aa0-a5a7-f3298a0e551a" finished successfully.
Created [https://cloudbuild.googleapis.com/v1/projects/global-cluster-2/builds/2856bbc1-e88e-4b8a-ba87-8a53b962b107].
Logs are available at [https://console.cloud.google.com/cloud-build/builds/2856bbc1-e88e-4b8a-ba87-8a53b962b107?project=115011585027].
--------------------------------------------------------------------------------------------------------- REMOTE BUILD OUTPUT ---------------------------------------------------------------------------------------------------------
starting build "2856bbc1-e88e-4b8a-ba87-8a53b962b107"

FETCHSOURCE
Fetching storage object: gs://global-cluster-2_cloudbuild/source/1606921779.223939-e942fb1fbfb744589a405578d78a3d25.tgz#1606921782188194
Copying gs://global-cluster-2_cloudbuild/source/1606921779.223939-e942fb1fbfb744589a405578d78a3d25.tgz#1606921782188194...
/ [1 files][  2.5 KiB/  2.5 KiB]
Operation completed over 1 objects/2.5 KiB.
BUILD
Already have image (with digest): gcr.io/cloud-builders/docker
Sending build context to Docker daemon  8.704kB
Step 1/7 : FROM python:3.9-slim
3.9-slim: Pulling from library/python
852e50cd189d: Pulling fs layer
38449967cae5: Pulling fs layer
d57cc5b29eb0: Pulling fs layer
9ee85f0d2615: Pulling fs layer
332a1ae54384: Pulling fs layer
9ee85f0d2615: Waiting
332a1ae54384: Waiting
38449967cae5: Verifying Checksum
38449967cae5: Download complete
d57cc5b29eb0: Verifying Checksum
d57cc5b29eb0: Download complete
852e50cd189d: Verifying Checksum
852e50cd189d: Download complete
9ee85f0d2615: Verifying Checksum
9ee85f0d2615: Download complete
332a1ae54384: Verifying Checksum
332a1ae54384: Download complete
852e50cd189d: Pull complete
38449967cae5: Pull complete
d57cc5b29eb0: Pull complete
9ee85f0d2615: Pull complete
332a1ae54384: Pull complete
Digest: sha256:bb9f441043eed9cb70013e2e683bba3b413d2d62753a884406b47e2111906851
Status: Downloaded newer image for python:3.9-slim
---> 18d7fc5fc589
Step 2/7 : ENV PYTHONUNBUFFERED True
---> Running in d0b1fc7bb1e8
Removing intermediate container d0b1fc7bb1e8
---> 2ee96b6332e6
Step 3/7 : ENV APP_HOME /app
---> Running in ccf5872c4293
Removing intermediate container ccf5872c4293
---> 0b2da30f7ffb
Step 4/7 : WORKDIR $APP_HOME
---> Running in 83af11017eb7
Removing intermediate container 83af11017eb7
---> 03ad3a36bde3
Step 5/7 : COPY . $APP_HOME
---> 42d464bcf560
Step 6/7 : RUN pip install Flask gunicorn
---> Running in 0a174a5bdc71
Collecting Flask
 Downloading Flask-1.1.2-py2.py3-none-any.whl (94 kB)
Collecting gunicorn
 Downloading gunicorn-20.0.4-py2.py3-none-any.whl (77 kB)
Requirement already satisfied: setuptools>=3.0 in /usr/local/lib/python3.9/site-packages (from gunicorn) (50.3.2)
Collecting click>=5.1
 Downloading click-7.1.2-py2.py3-none-any.whl (82 kB)
Collecting itsdangerous>=0.24
 Downloading itsdangerous-1.1.0-py2.py3-none-any.whl (16 kB)
Collecting Jinja2>=2.10.1
 Downloading Jinja2-2.11.2-py2.py3-none-any.whl (125 kB)
Collecting MarkupSafe>=0.23
 Downloading MarkupSafe-1.1.1.tar.gz (19 kB)
Collecting Werkzeug>=0.15
 Downloading Werkzeug-1.0.1-py2.py3-none-any.whl (298 kB)
Building wheels for collected packages: MarkupSafe
 Building wheel for MarkupSafe (setup.py): started
 Building wheel for MarkupSafe (setup.py): finished with status 'done'
 Created wheel for MarkupSafe: filename=MarkupSafe-1.1.1-py3-none-any.whl size=12627 sha256=cdf0a1391b79aae7e394bfd12b1640c64449eb48a6600bbb155dfb97f25ac5c5
 Stored in directory: /root/.cache/pip/wheels/e0/19/6f/6ba857621f50dc08e084312746ed3ebc14211ba30037d5e44e
Successfully built MarkupSafe
Installing collected packages: MarkupSafe, Werkzeug, Jinja2, itsdangerous, click, gunicorn, Flask
Successfully installed Flask-1.1.2 Jinja2-2.11.2 MarkupSafe-1.1.1 Werkzeug-1.0.1 click-7.1.2 gunicorn-20.0.4 itsdangerous-1.1.0
Removing intermediate container 0a174a5bdc71
---> e3a5f80e859a
Step 7/7 : CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 main:app
---> Running in 51e3d46a61d6
Removing intermediate container 51e3d46a61d6
---> 313d8663790c
Successfully built 313d8663790c
Successfully tagged gcr.io/global-cluster-2/helloworld:latest
PUSH
Pushing gcr.io/global-cluster-2/helloworld
The push refers to repository [gcr.io/global-cluster-2/helloworld]
7422dfd93abd: Preparing
95f8e1290db4: Preparing
e806bbea4093: Preparing
10aa75f19973: Preparing
7f87da26703a: Preparing
889e9591fc68: Preparing
0d92fd747771: Preparing
f5600c6330da: Preparing
889e9591fc68: Waiting
0d92fd747771: Waiting
f5600c6330da: Waiting
7f87da26703a: Layer already exists
889e9591fc68: Layer already exists
0d92fd747771: Layer already exists
f5600c6330da: Layer already exists
e806bbea4093: Pushed
95f8e1290db4: Pushed
10aa75f19973: Pushed
7422dfd93abd: Pushed
latest: digest: sha256:635e84aca906d9c3c85e195e1515625e4d1511a8562f6b960b88ea8071e98310 size: 1996
DONE
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ID                                    CREATE_TIME                DURATION  SOURCE                                                                                          IMAGES                                        STATUS
2856bbc1-e88e-4b8a-ba87-8a53b962b107  2020-12-02T15:09:58+00:00  31S       gs://global-cluster-2_cloudbuild/source/1606921779.223939-e942fb1fbfb744589a405578d78a3d25.tgz  gcr.io/global-cluster-2/helloworld (+1 more)  SUCCESS
dmitrogavrichuk@iMac-Dmitro  ~/DEVOPS/Mesoform/global_structure_test/app_1/build/helloworld  cd ../../../terraform
dmitrogavrichuk@iMac-Dmitro  ~/DEVOPS/Mesoform/global_structure_test/terraform  gcloud container clusters get-credentials global-cluster-2-gke --region europe-west2 --project global-cluster-2
Fetching cluster endpoint and auth data.
kubeconfig entry generated for global-cluster-2-gke.
dmitrogavrichuk@iMac-Dmitro  ~/DEVOPS/Mesoform/global_structure_test/terraform 

#***********************************************************************************************
#the command «terraform apply» is executed without deleting terraform files from the old project
#***********************************************************************************************

dmitrogavrichuk@iMac-Dmitro  ~/DEVOPS/Mesoform/global_structure_test/terraform  terraform apply
module.mcp.data.google_project.self[0]: Refreshing state... [id=projects/global-cluster]
module.mcp.data.google_iam_policy.auth["default"]: Refreshing state...
module.mcp.data.google_iam_policy.noauth["default"]: Refreshing state...
module.mcp.data.google_project.default[0]: Refreshing state... [id=projects/global-cluster]
module.mcp.google_project_service.iam[0]: Refreshing state... [id=global-cluster/iam.googleapis.com]
module.mcp.google_project_service.cloudrun[0]: Refreshing state... [id=global-cluster/run.googleapis.com]
module.mcp.google_project_service.std[0]: Refreshing state... [id=global-cluster/appengine.googleapis.com]
module.mcp.google_storage_bucket.self[0]: Refreshing state... [id=global-cluster]
module.mcp.google_app_engine_standard_app_version.self["default"]: Refreshing state... [id=apps/global-cluster/services/default/versions/1]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
 + create
-/+ destroy and then create replacement

Terraform will perform the following actions:

 # module.mcp.google_app_engine_application.self[0] will be created
 + resource "google_app_engine_application" "self" {
     + app_id            = (known after apply)
     + auth_domain       = (known after apply)
     + code_bucket       = (known after apply)
     + database_type     = (known after apply)
     + default_bucket    = (known after apply)
     + default_hostname  = (known after apply)
     + gcr_domain        = (known after apply)
     + id                = (known after apply)
     + location_id       = "europe-west2"
     + name              = (known after apply)
     + project           = "global-cluster-2"
     + serving_status    = (known after apply)
     + url_dispatch_rule = (known after apply)

     + feature_settings {
         + split_health_checks = (known after apply)
       }

     + iap {
         + enabled                     = (known after apply)
         + oauth2_client_id            = (known after apply)
         + oauth2_client_secret        = (sensitive value)
         + oauth2_client_secret_sha256 = (sensitive value)
       }
   }

 # module.mcp.google_app_engine_standard_app_version.self["default"] must be replaced
-/+ resource "google_app_engine_standard_app_version" "self" {
       delete_service_on_destroy = false
     ~ env_variables             = {
         ~ "GCP_PROJECT_ID" = "global-cluster" -> "global-cluster-2"
       }
     ~ id                        = "apps/global-cluster/services/default/versions/1" -> (known after apply)
     - inbound_services          = [] -> null
     ~ instance_class            = "F1" -> (known after apply)
     ~ name                      = "apps/global-cluster/services/default/versions/1" -> (known after apply)
       noop_on_destroy           = false
     ~ project                   = "global-cluster" -> "global-cluster-2" # forces replacement
       runtime                   = "python37"
       service                   = "default"
       version_id                = "1"

     ~ deployment {
         - files {
             - name       = "main.py" -> null
             - sha1_sum   = "4d0fb4c1f3ad45b59f46ccf49df8d5444668727b" -> null
             - source_url = "https://storage.googleapis.com/global-cluster/4d0fb4c1f3ad45b59f46ccf49df8d5444668727b" -> null
           }
         + files {
             + name       = "main.py"
             + sha1_sum   = "6bcd5ab8b7d46f59780ba2497c112294220aa0cb"
             + source_url = "https://storage.googleapis.com/global-cluster-2/6bcd5ab8b7d46f59780ba2497c112294220aa0cb"
           }
         + files {
             + name       = "requirements.txt"
             + sha1_sum   = "570b1896080f7368d7a8737d020cfe252416d2c9"
             + source_url = "https://storage.googleapis.com/global-cluster-2/570b1896080f7368d7a8737d020cfe252416d2c9"
           }
         - files {
             - name       = "requirements.txt" -> null
             - sha1_sum   = "570b1896080f7368d7a8737d020cfe252416d2c9" -> null
             - source_url = "https://storage.googleapis.com/global-cluster/570b1896080f7368d7a8737d020cfe252416d2c9" -> null
           }
       }

       entrypoint {
           shell = "python main.py"
       }

     ~ handlers {
         ~ auth_fail_action            = "AUTH_FAIL_ACTION_REDIRECT" -> (known after apply)
         ~ login                       = "LOGIN_OPTIONAL" -> (known after apply)
         + redirect_http_response_code = (known after apply)
         ~ security_level              = "SECURE_OPTIONAL" -> (known after apply)
         ~ url_regex                   = ".*" -> (known after apply)

         ~ script {
             ~ script_path = "auto" -> (known after apply)
           }

         + static_files {
             + application_readable  = (known after apply)
             + expiration            = (known after apply)
             + http_headers          = (known after apply)
             + mime_type             = (known after apply)
             + path                  = (known after apply)
             + require_matching_file = (known after apply)
             + upload_path_regex     = (known after apply)
           }
       }
   }

 # module.mcp.google_cloud_run_service.self["default"] will be created
 + resource "google_cloud_run_service" "self" {
     + autogenerate_revision_name = false
     + id                         = (known after apply)
     + location                   = "europe-west2"
     + name                       = "default"
     + project                    = "global-cluster-2"
     + status                     = (known after apply)

     + metadata {
         + annotations      = (known after apply)
         + generation       = (known after apply)
         + labels           = (known after apply)
         + namespace        = (known after apply)
         + resource_version = (known after apply)
         + self_link        = (known after apply)
         + uid              = (known after apply)
       }

     + template {
         + metadata {
             + annotations      = {
                 + "autoscaling.knative.dev/maxScale" = "1000"
                 + "run.googleapis.com/client-name"   = "terraform"
               }
             + generation       = (known after apply)
             + name             = (known after apply)
             + namespace        = (known after apply)
             + resource_version = (known after apply)
             + self_link        = (known after apply)
             + uid              = (known after apply)
           }

         + spec {
             + container_concurrency = (known after apply)
             + serving_state         = (known after apply)
             + timeout_seconds       = (known after apply)

             + containers {
                 + image = "gcr.io/global-cluster-2/helloworld"

                 + ports {
                     + container_port = (known after apply)
                     + name           = (known after apply)
                     + protocol       = (known after apply)
                   }

                 + resources {
                     + limits   = (known after apply)
                     + requests = (known after apply)
                   }
               }
           }
       }

     + traffic {
         + latest_revision = (known after apply)
         + percent         = (known after apply)
         + revision_name   = (known after apply)
       }
   }

 # module.mcp.google_cloud_run_service_iam_policy.self["default"] will be created
 + resource "google_cloud_run_service_iam_policy" "self" {
     + etag        = (known after apply)
     + id          = (known after apply)
     + location    = "europe-west2"
     + policy_data = jsonencode(
           {
             + bindings = [
                 + {
                     + members = [
                         + "allUsers",
                       ]
                     + role    = "roles/run.invoker"
                   },
               ]
           }
       )
     + project     = "global-cluster-2"
     + service     = "default"
   }

 # module.mcp.google_project_service.cloudrun[0] must be replaced
-/+ resource "google_project_service" "cloudrun" {
     + disable_dependent_services = true
       disable_on_destroy         = true
     ~ id                         = "global-cluster/run.googleapis.com" -> (known after apply)
     ~ project                    = "global-cluster" -> "global-cluster-2" # forces replacement
       service                    = "run.googleapis.com"
   }

 # module.mcp.google_project_service.iam[0] must be replaced
-/+ resource "google_project_service" "iam" {
     ~ disable_on_destroy = true -> false
     ~ id                 = "global-cluster/iam.googleapis.com" -> (known after apply)
     ~ project            = "global-cluster" -> "global-cluster-2" # forces replacement
       service            = "iam.googleapis.com"
   }

 # module.mcp.google_project_service.std[0] must be replaced
-/+ resource "google_project_service" "std" {
       disable_dependent_services = true
       disable_on_destroy         = true
     ~ id                         = "global-cluster/appengine.googleapis.com" -> (known after apply)
     ~ project                    = "global-cluster" -> "global-cluster-2" # forces replacement
       service                    = "appengine.googleapis.com"
   }

 # module.mcp.google_storage_bucket.self[0] must be replaced
-/+ resource "google_storage_bucket" "self" {
     ~ bucket_policy_only          = true -> (known after apply)
       default_event_based_hold    = false
       force_destroy               = true
     ~ id                          = "global-cluster" -> (known after apply)
       labels                      = {
           "billing" = "central"
       }
       location                    = "EUROPE-WEST2"
     ~ name                        = "global-cluster" -> "global-cluster-2" # forces replacement
     ~ project                     = "global-cluster" -> "global-cluster-2" # forces replacement
       requester_pays              = false
     ~ self_link                   = "https://www.googleapis.com/storage/v1/b/global-cluster" -> (known after apply)
       storage_class               = "REGIONAL"
       uniform_bucket_level_access = true
     ~ url                         = "gs://global-cluster" -> (known after apply)

       versioning {
           enabled = true
       }
   }

 # module.mcp.google_storage_bucket_object.self["../app_1/build/helloworld/main.py"] will be created
 + resource "google_storage_bucket_object" "self" {
     + bucket         = "global-cluster-2"
     + content_type   = (known after apply)
     + crc32c         = (known after apply)
     + detect_md5hash = "different hash"
     + id             = (known after apply)
     + md5hash        = (known after apply)
     + media_link     = (known after apply)
     + name           = "6bcd5ab8b7d46f59780ba2497c112294220aa0cb"
     + output_name    = (known after apply)
     + self_link      = (known after apply)
     + source         = "../app_1/build/helloworld/main.py"
     + storage_class  = (known after apply)
   }

 # module.mcp.google_storage_bucket_object.self["../app_1/build/helloworld/requirements.txt"] will be created
 + resource "google_storage_bucket_object" "self" {
     + bucket         = "global-cluster-2"
     + content_type   = (known after apply)
     + crc32c         = (known after apply)
     + detect_md5hash = "different hash"
     + id             = (known after apply)
     + md5hash        = (known after apply)
     + media_link     = (known after apply)
     + name           = "570b1896080f7368d7a8737d020cfe252416d2c9"
     + output_name    = (known after apply)
     + self_link      = (known after apply)
     + source         = "../app_1/build/helloworld/requirements.txt"
     + storage_class  = (known after apply)
   }

 # module.mcp.kubernetes_config_map.self["app_1"] will be created
 + resource "kubernetes_config_map" "self" {
     + binary_data = {
         + "bar"        = "L3Jvb3QvMTAw"
         + "binary.bin" = "SGVsbG8gV29ybGQ="
       }
     + data        = {
         + "mosquitto.conf" = <<~EOT
               log_dest stdout
               log_type all
               log_timestamp true
               listener 9001
           EOT
         + "test"           = "test"
       }
     + id          = (known after apply)

     + metadata {
         + generation       = (known after apply)
         + labels           = {
             + "env" = "test"
           }
         + name             = "mosquitto-config-file"
         + namespace        = "default"
         + resource_version = (known after apply)
         + self_link        = (known after apply)
         + uid              = (known after apply)
       }
   }

 # module.mcp.kubernetes_deployment.self["app_1"] will be created
 + resource "kubernetes_deployment" "self" {
     + id               = (known after apply)
     + wait_for_rollout = true

     + metadata {
         + generation       = (known after apply)
         + labels           = {
             + "app" = "mosquitto"
           }
         + name             = "mosquitto"
         + namespace        = "default"
         + resource_version = (known after apply)
         + self_link        = (known after apply)
         + uid              = (known after apply)
       }

     + spec {
         + min_ready_seconds         = 0
         + paused                    = false
         + progress_deadline_seconds = 600
         + replicas                  = 1
         + revision_history_limit    = 10

         + selector {
             + match_labels = {
                 + "app" = "mosquitto"
               }
           }

         + strategy {
             + type = (known after apply)

             + rolling_update {
                 + max_surge       = (known after apply)
                 + max_unavailable = (known after apply)
               }
           }

         + template {
             + metadata {
                 + generation       = (known after apply)
                 + labels           = {
                     + "app" = "mosquitto"
                   }
                 + name             = (known after apply)
                 + resource_version = (known after apply)
                 + self_link        = (known after apply)
                 + uid              = (known after apply)
               }

             + spec {
                 + dns_policy                       = "ClusterFirst"
                 + enable_service_links             = true
                 + host_ipc                         = false
                 + host_network                     = false
                 + host_pid                         = false
                 + hostname                         = (known after apply)
                 + node_name                        = (known after apply)
                 + restart_policy                   = "Always"
                 + service_account_name             = (known after apply)
                 + share_process_namespace          = false
                 + termination_grace_period_seconds = 30

                 + container {
                     + image                      = "eclipse-mosquitto:1.6.2"
                     + image_pull_policy          = (known after apply)
                     + name                       = "mosquitto"
                     + stdin                      = false
                     + stdin_once                 = false
                     + termination_message_path   = "/dev/termination-log"
                     + termination_message_policy = (known after apply)
                     + tty                        = false

                     + port {
                         + container_port = 1883
                         + protocol       = "TCP"
                       }

                     + resources {
                         + limits {
                             + cpu    = "0.5"
                             + memory = "512Mi"
                           }

                         + requests {
                             + cpu    = "250m"
                             + memory = "50Mi"
                           }
                       }

                     + volume_mount {
                         + mount_path        = "/mosquitto/secret"
                         + mount_propagation = "None"
                         + name              = "mosquitto-secret-file"
                         + read_only         = false
                       }
                     + volume_mount {
                         + mount_path        = "mosquitto/config"
                         + mount_propagation = "None"
                         + name              = "mosquitto-config-file"
                         + read_only         = false
                       }
                   }
                 + container {
                     + image                      = "tomcat:8.5-jdk8-adoptopenjdk-openj9"
                     + image_pull_policy          = (known after apply)
                     + name                       = "tomcat-example"
                     + stdin                      = false
                     + stdin_once                 = false
                     + termination_message_path   = "/dev/termination-log"
                     + termination_message_policy = (known after apply)
                     + tty                        = false

                     + port {
                         + container_port = 8080
                         + protocol       = "TCP"
                       }

                     + resources {
                         + limits {
                             + cpu    = "0.5"
                             + memory = "512Mi"
                           }

                         + requests {
                             + cpu    = "250m"
                             + memory = "50Mi"
                           }
                       }

                     + volume_mount {
                         + mount_path        = (known after apply)
                         + mount_propagation = (known after apply)
                         + name              = (known after apply)
                         + read_only         = (known after apply)
                         + sub_path          = (known after apply)
                       }
                   }

                 + image_pull_secrets {
                     + name = (known after apply)
                   }

                 + volume {
                     + name = "mosquitto-config-file"

                     + config_map {
                         + default_mode = "0644"
                         + name         = "mosquitto-config-file"
                       }
                   }
                 + volume {
                     + name = "mosquitto-secret-file"

                     + secret {
                         + default_mode = "0644"
                         + secret_name  = "mosquitto-secret-file"
                       }
                   }
               }
           }
       }
   }

 # module.mcp.kubernetes_pod.self["app_2"] will be created
 + resource "kubernetes_pod" "self" {
     + id = (known after apply)

     + metadata {
         + generation       = (known after apply)
         + labels           = {
             + "app" = "TestApp"
           }
         + name             = "nginx-example"
         + namespace        = "default"
         + resource_version = (known after apply)
         + self_link        = (known after apply)
         + uid              = (known after apply)
       }

     + spec {
         + automount_service_account_token  = false
         + dns_policy                       = "None"
         + enable_service_links             = true
         + host_ipc                         = false
         + host_network                     = false
         + host_pid                         = false
         + hostname                         = (known after apply)
         + node_name                        = (known after apply)
         + restart_policy                   = "Always"
         + service_account_name             = "pod-app-service-account"
         + share_process_namespace          = false
         + termination_grace_period_seconds = 30

         + container {
             + image                      = "nginx:1.7.8"
             + image_pull_policy          = (known after apply)
             + name                       = "nginx-example"
             + stdin                      = false
             + stdin_once                 = false
             + termination_message_path   = "/dev/termination-log"
             + termination_message_policy = (known after apply)
             + tty                        = false

             + liveness_probe {
                 + failure_threshold     = 3
                 + initial_delay_seconds = 3
                 + period_seconds        = 3
                 + success_threshold     = 1
                 + timeout_seconds       = 1

                 + http_get {
                     + path   = "/"
                     + port   = "80"
                     + scheme = "HTTP"

                     + http_header {
                         + name  = "X-Custom-Header"
                         + value = "Awesome"
                       }
                   }
               }

             + port {
                 + container_port = 8080
                 + protocol       = "TCP"
               }

             + resources {
                 + limits {
                     + cpu    = (known after apply)
                     + memory = (known after apply)
                   }

                 + requests {
                     + cpu    = (known after apply)
                     + memory = (known after apply)
                   }
               }

             + volume_mount {
                 + mount_path        = (known after apply)
                 + mount_propagation = (known after apply)
                 + name              = (known after apply)
                 + read_only         = (known after apply)
                 + sub_path          = (known after apply)
               }
           }

         + dns_config {
             + nameservers = [
                 + "1.1.1.1",
                 + "8.8.8.8",
                 + "9.9.9.9",
               ]
             + searches    = [
                 + "example.com",
               ]

             + option {
                 + name  = "ndots"
                 + value = "1"
               }
             + option {
                 + name = "use-vc"
               }
           }

         + image_pull_secrets {
             + name = (known after apply)
           }

         + volume {
             + name = (known after apply)

             + aws_elastic_block_store {
                 + fs_type   = (known after apply)
                 + partition = (known after apply)
                 + read_only = (known after apply)
                 + volume_id = (known after apply)
               }

             + azure_disk {
                 + caching_mode  = (known after apply)
                 + data_disk_uri = (known after apply)
                 + disk_name     = (known after apply)
                 + fs_type       = (known after apply)
                 + kind          = (known after apply)
                 + read_only     = (known after apply)
               }

             + azure_file {
                 + read_only   = (known after apply)
                 + secret_name = (known after apply)
                 + share_name  = (known after apply)
               }

             + ceph_fs {
                 + monitors    = (known after apply)
                 + path        = (known after apply)
                 + read_only   = (known after apply)
                 + secret_file = (known after apply)
                 + user        = (known after apply)

                 + secret_ref {
                     + name      = (known after apply)
                     + namespace = (known after apply)
                   }
               }

             + cinder {
                 + fs_type   = (known after apply)
                 + read_only = (known after apply)
                 + volume_id = (known after apply)
               }

             + config_map {
                 + default_mode = (known after apply)
                 + name         = (known after apply)
                 + optional     = (known after apply)

                 + items {
                     + key  = (known after apply)
                     + mode = (known after apply)
                     + path = (known after apply)
                   }
               }

             + csi {
                 + driver            = (known after apply)
                 + fs_type           = (known after apply)
                 + read_only         = (known after apply)
                 + volume_attributes = (known after apply)
                 + volume_handle     = (known after apply)

                 + controller_expand_secret_ref {
                     + name      = (known after apply)
                     + namespace = (known after apply)
                   }

                 + controller_publish_secret_ref {
                     + name      = (known after apply)
                     + namespace = (known after apply)
                   }

                 + node_publish_secret_ref {
                     + name      = (known after apply)
                     + namespace = (known after apply)
                   }

                 + node_stage_secret_ref {
                     + name      = (known after apply)
                     + namespace = (known after apply)
                   }
               }

             + downward_api {
                 + default_mode = (known after apply)

                 + items {
                     + mode = (known after apply)
                     + path = (known after apply)

                     + field_ref {
                         + api_version = (known after apply)
                         + field_path  = (known after apply)
                       }

                     + resource_field_ref {
                         + container_name = (known after apply)
                         + quantity       = (known after apply)
                         + resource       = (known after apply)
                       }
                   }
               }

             + empty_dir {
                 + medium     = (known after apply)
                 + size_limit = (known after apply)
               }

             + fc {
                 + fs_type      = (known after apply)
                 + lun          = (known after apply)
                 + read_only    = (known after apply)
                 + target_ww_ns = (known after apply)
               }

             + flex_volume {
                 + driver    = (known after apply)
                 + fs_type   = (known after apply)
                 + options   = (known after apply)
                 + read_only = (known after apply)

                 + secret_ref {
                     + name      = (known after apply)
                     + namespace = (known after apply)
                   }
               }

             + flocker {
                 + dataset_name = (known after apply)
                 + dataset_uuid = (known after apply)
               }

             + gce_persistent_disk {
                 + fs_type   = (known after apply)
                 + partition = (known after apply)
                 + pd_name   = (known after apply)
                 + read_only = (known after apply)
               }

             + git_repo {
                 + directory  = (known after apply)
                 + repository = (known after apply)
                 + revision   = (known after apply)
               }

             + glusterfs {
                 + endpoints_name = (known after apply)
                 + path           = (known after apply)
                 + read_only      = (known after apply)
               }

             + host_path {
                 + path = (known after apply)
                 + type = (known after apply)
               }

             + iscsi {
                 + fs_type         = (known after apply)
                 + iqn             = (known after apply)
                 + iscsi_interface = (known after apply)
                 + lun             = (known after apply)
                 + read_only       = (known after apply)
                 + target_portal   = (known after apply)
               }

             + local {
                 + path = (known after apply)
               }

             + nfs {
                 + path      = (known after apply)
                 + read_only = (known after apply)
                 + server    = (known after apply)
               }

             + persistent_volume_claim {
                 + claim_name = (known after apply)
                 + read_only  = (known after apply)
               }

             + photon_persistent_disk {
                 + fs_type = (known after apply)
                 + pd_id   = (known after apply)
               }

             + projected {
                 + default_mode = (known after apply)

                 + sources {
                     + config_map {
                         + name     = (known after apply)
                         + optional = (known after apply)

                         + items {
                             + key  = (known after apply)
                             + mode = (known after apply)
                             + path = (known after apply)
                           }
                       }

                     + downward_api {
                         + items {
                             + mode = (known after apply)
                             + path = (known after apply)

                             + field_ref {
                                 + api_version = (known after apply)
                                 + field_path  = (known after apply)
                               }

                             + resource_field_ref {
                                 + container_name = (known after apply)
                                 + quantity       = (known after apply)
                                 + resource       = (known after apply)
                               }
                           }
                       }

                     + secret {
                         + name     = (known after apply)
                         + optional = (known after apply)

                         + items {
                             + key  = (known after apply)
                             + mode = (known after apply)
                             + path = (known after apply)
                           }
                       }

                     + service_account_token {
                         + audience           = (known after apply)
                         + expiration_seconds = (known after apply)
                         + path               = (known after apply)
                       }
                   }
               }

             + quobyte {
                 + group     = (known after apply)
                 + read_only = (known after apply)
                 + registry  = (known after apply)
                 + user      = (known after apply)
                 + volume    = (known after apply)
               }

             + rbd {
                 + ceph_monitors = (known after apply)
                 + fs_type       = (known after apply)
                 + keyring       = (known after apply)
                 + rados_user    = (known after apply)
                 + rbd_image     = (known after apply)
                 + rbd_pool      = (known after apply)
                 + read_only     = (known after apply)

                 + secret_ref {
                     + name      = (known after apply)
                     + namespace = (known after apply)
                   }
               }

             + secret {
                 + default_mode = (known after apply)
                 + optional     = (known after apply)
                 + secret_name  = (known after apply)

                 + items {
                     + key  = (known after apply)
                     + mode = (known after apply)
                     + path = (known after apply)
                   }
               }

             + vsphere_volume {
                 + fs_type     = (known after apply)
                 + volume_path = (known after apply)
               }
           }
       }
   }

 # module.mcp.kubernetes_secret.self["app_1"] will be created
 + resource "kubernetes_secret" "self" {
     + data = (sensitive value)
     + id   = (known after apply)
     + type = "Opaque"

     + metadata {
         + generation       = (known after apply)
         + labels           = {
             + "env" = "test"
           }
         + name             = "mosquitto-secret-file"
         + namespace        = "default"
         + resource_version = (known after apply)
         + self_link        = (known after apply)
         + uid              = (known after apply)
       }
   }

 # module.mcp.kubernetes_service.self["app_1"] will be created
 + resource "kubernetes_service" "self" {
     + id                    = (known after apply)
     + load_balancer_ingress = (known after apply)

     + metadata {
         + generation       = (known after apply)
         + labels           = {
             + "env" = "test"
           }
         + name             = "mosquitto"
         + namespace        = "default"
         + resource_version = (known after apply)
         + self_link        = (known after apply)
         + uid              = (known after apply)
       }

     + spec {
         + cluster_ip                  = (known after apply)
         + external_traffic_policy     = (known after apply)
         + health_check_node_port      = (known after apply)
         + publish_not_ready_addresses = false
         + selector                    = {
             + "app" = "mosquitto"
           }
         + session_affinity            = "None"
         + type                        = "LoadBalancer"

         + port {
             + name        = "mosquitto-listener"
             + node_port   = (known after apply)
             + port        = 1883
             + protocol    = "TCP"
             + target_port = "1883"
           }
         + port {
             + name        = "tomcat-listener"
             + node_port   = (known after apply)
             + port        = 80
             + protocol    = "TCP"
             + target_port = "8080"
           }
       }
   }

 # module.mcp.kubernetes_service_account.self["app_2"] will be created
 + resource "kubernetes_service_account" "self" {
     + automount_service_account_token = false
     + default_secret_name             = (known after apply)
     + id                              = (known after apply)

     + metadata {
         + generation       = (known after apply)
         + name             = "pod-app-service-account"
         + namespace        = "default"
         + resource_version = (known after apply)
         + self_link        = (known after apply)
         + uid              = (known after apply)
       }

     + secret {
         + name = "pod-app-secret-file"
       }
   }

Plan: 16 to add, 0 to change, 5 to destroy.

Changes to Outputs:
 + k8s_components       = {
     + common = {
         + name = "name"
       }
     + specs  = {
         + app_1   = {
             + config_map = {
                 + binary_data = {
                     + bar = "L3Jvb3QvMTAw"
                   }
                 + binary_file = [
                     + "../app_2/resources/binary.bin",
                   ]
                 + data        = {
                     + test = "test"
                   }
                 + data_file   = [
                     + "../app_2/resources/mosquitto.conf",
                   ]
                 + metadata    = {
                     + labels = {
                         + env = "test"
                       }
                     + name   = "mosquitto-config-file"
                   }
               }
             + deployment = {
                 + metadata = {
                     + labels    = {
                         + app = "mosquitto"
                       }
                     + name      = "mosquitto"
                     + namespace = null
                   }
                 + spec     = {
                     + replicas = 1
                     + selector = {
                         + match_labels = {
                             + app = "mosquitto"
                           }
                       }
                     + template = {
                         + metadata = {
                             + labels = {
                                 + app = "mosquitto"
                               }
                           }
                         + spec     = {
                             + container = [
                                 + {
                                     + image        = "eclipse-mosquitto:1.6.2"
                                     + name         = "mosquitto"
                                     + port         = [
                                         + {
                                             + container_port = 1883
                                           },
                                       ]
                                     + resources    = {
                                         + limits   = {
                                             + cpu    = "0.5"
                                             + memory = "512Mi"
                                           }
                                         + requests = {
                                             + cpu    = "250m"
                                             + memory = "50Mi"
                                           }
                                       }
                                     + volume_mount = [
                                         + {
                                             + mount_path = "/mosquitto/secret"
                                             + name       = "mosquitto-secret-file"
                                           },
                                         + {
                                             + mount_path = "mosquitto/config"
                                             + name       = "mosquitto-config-file"
                                           },
                                       ]
                                   },
                                 + {
                                     + image     = "tomcat:8.5-jdk8-adoptopenjdk-openj9"
                                     + name      = "tomcat-example"
                                     + port      = [
                                         + {
                                             + container_port = 8080
                                           },
                                       ]
                                     + resources = {
                                         + limits   = {
                                             + cpu    = "0.5"
                                             + memory = "512Mi"
                                           }
                                         + requests = {
                                             + cpu    = "250m"
                                             + memory = "50Mi"
                                           }
                                       }
                                   },
                               ]
                             + volume    = [
                                 + {
                                     + config_map = {
                                         + name = "mosquitto-config-file"
                                       }
                                     + name       = "mosquitto-config-file"
                                   },
                                 + {
                                     + name   = "mosquitto-secret-file"
                                     + secret = {
                                         + secret_name = "mosquitto-secret-file"
                                       }
                                   },
                               ]
                           }
                       }
                   }
               }
             + secret     = {
                 + data      = {
                     + login    = "login"
                     + password = "password"
                   }
                 + data_file = [
                     + "../app_2/resources/secret.file",
                   ]
                 + metadata  = {
                     + annotations = {
                         + key1 = null
                         + key2 = null
                       }
                     + labels      = {
                         + env = "test"
                       }
                     + name        = "mosquitto-secret-file"
                     + namespace   = null
                   }
                 + type      = "Opaque"
               }
             + service    = {
                 + metadata = {
                     + generate_name = null
                     + labels        = {
                         + env = "test"
                       }
                     + name          = "mosquitto"
                     + namespace     = null
                   }
                 + spec     = {
                     + port     = [
                         + {
                             + name        = "mosquitto-listener"
                             + port        = 1883
                             + target_port = 1883
                           },
                         + {
                             + name        = "tomcat-listener"
                             + port        = 80
                             + target_port = 8080
                           },
                       ]
                     + selector = {
                         + app = "mosquitto"
                       }
                     + type     = "LoadBalancer"
                   }
               }
           }
         + app_2   = {
             + k8s_pod_autoscaler = {
                 + metadata = {
                     + name = "test"
                   }
                 + spec     = {
                     + max_replicas     = 100
                     + metric           = {
                         + external = {
                             + metric = {
                                 + name     = "latency"
                                 + selector = {
                                     + match_labels = {
                                         + lb_name = "test"
                                       }
                                   }
                               }
                             + target = {
                                 + type  = "Value"
                                 + value = 100
                               }
                           }
                         + type     = "External"
                       }
                     + min_replicas     = 50
                     + scale_target_ref = {
                         + kind = "Deployment"
                         + name = "MyApp"
                       }
                   }
               }
             + pod                = {
                 + metadata = {
                     + labels    = {
                         + app = "TestApp"
                       }
                     + name      = "nginx-example"
                     + namespace = null
                   }
                 + spec     = {
                     + container            = [
                         + {
                             + image          = "nginx:1.7.8"
                             + liveness_probe = {
                                 + http_get              = {
                                     + http_header = {
                                         + name  = "X-Custom-Header"
                                         + value = "Awesome"
                                       }
                                     + path        = "/"
                                     + port        = 80
                                   }
                                 + initial_delay_seconds = 3
                                 + period_seconds        = 3
                               }
                             + name           = "nginx-example"
                             + port           = [
                                 + {
                                     + container_port = 8080
                                   },
                               ]
                           },
                       ]
                     + dns_config           = {
                         + nameservers = [
                             + "1.1.1.1",
                             + "8.8.8.8",
                             + "9.9.9.9",
                           ]
                         + option      = [
                             + {
                                 + name  = "ndots"
                                 + value = 1
                               },
                             + {
                                 + name = "use-vc"
                               },
                           ]
                         + searches    = [
                             + "example.com",
                           ]
                       }
                     + dns_policy           = "None"
                     + env                  = {
                         + name  = "environment"
                         + value = "test"
                       }
                     + secret               = "pod-app-service-account-token-brds5"
                     + service_account_name = "pod-app-service-account"
                   }
               }
             + service_account    = {
                 + automount_service_account_token = true
                 + metadata                        = {
                     + name = "pod-app-service-account"
                   }
                 + secret                          = [
                     + {
                         + name = "pod-app-secret-file"
                       },
                   ]
               }
           }
         + default = {
             + build_dir      = "build"
             + manual_scaling = {
                 + instances = 1
               }
             + root_dir       = "mcp"
             + runtime        = "java8"
           }
       }
   }
 + k8s_components_specs = {
     + app_1   = {
         + config_map = {
             + binary_data = {
                 + bar = "L3Jvb3QvMTAw"
               }
             + binary_file = [
                 + "../app_2/resources/binary.bin",
               ]
             + data        = {
                 + test = "test"
               }
             + data_file   = [
                 + "../app_2/resources/mosquitto.conf",
               ]
             + metadata    = {
                 + labels = {
                     + env = "test"
                   }
                 + name   = "mosquitto-config-file"
               }
           }
         + deployment = {
             + metadata = {
                 + labels    = {
                     + app = "mosquitto"
                   }
                 + name      = "mosquitto"
                 + namespace = null
               }
             + spec     = {
                 + replicas = 1
                 + selector = {
                     + match_labels = {
                         + app = "mosquitto"
                       }
                   }
                 + template = {
                     + metadata = {
                         + labels = {
                             + app = "mosquitto"
                           }
                       }
                     + spec     = {
                         + container = [
                             + {
                                 + image        = "eclipse-mosquitto:1.6.2"
                                 + name         = "mosquitto"
                                 + port         = [
                                     + {
                                         + container_port = 1883
                                       },
                                   ]
                                 + resources    = {
                                     + limits   = {
                                         + cpu    = "0.5"
                                         + memory = "512Mi"
                                       }
                                     + requests = {
                                         + cpu    = "250m"
                                         + memory = "50Mi"
                                       }
                                   }
                                 + volume_mount = [
                                     + {
                                         + mount_path = "/mosquitto/secret"
                                         + name       = "mosquitto-secret-file"
                                       },
                                     + {
                                         + mount_path = "mosquitto/config"
                                         + name       = "mosquitto-config-file"
                                       },
                                   ]
                               },
                             + {
                                 + image     = "tomcat:8.5-jdk8-adoptopenjdk-openj9"
                                 + name      = "tomcat-example"
                                 + port      = [
                                     + {
                                         + container_port = 8080
                                       },
                                   ]
                                 + resources = {
                                     + limits   = {
                                         + cpu    = "0.5"
                                         + memory = "512Mi"
                                       }
                                     + requests = {
                                         + cpu    = "250m"
                                         + memory = "50Mi"
                                       }
                                   }
                               },
                           ]
                         + volume    = [
                             + {
                                 + config_map = {
                                     + name = "mosquitto-config-file"
                                   }
                                 + name       = "mosquitto-config-file"
                               },
                             + {
                                 + name   = "mosquitto-secret-file"
                                 + secret = {
                                     + secret_name = "mosquitto-secret-file"
                                   }
                               },
                           ]
                       }
                   }
               }
           }
         + secret     = {
             + data      = {
                 + login    = "login"
                 + password = "password"
               }
             + data_file = [
                 + "../app_2/resources/secret.file",
               ]
             + metadata  = {
                 + annotations = {
                     + key1 = null
                     + key2 = null
                   }
                 + labels      = {
                     + env = "test"
                   }
                 + name        = "mosquitto-secret-file"
                 + namespace   = null
               }
             + type      = "Opaque"
           }
         + service    = {
             + metadata = {
                 + generate_name = null
                 + labels        = {
                     + env = "test"
                   }
                 + name          = "mosquitto"
                 + namespace     = null
               }
             + spec     = {
                 + port     = [
                     + {
                         + name        = "mosquitto-listener"
                         + port        = 1883
                         + target_port = 1883
                       },
                     + {
                         + name        = "tomcat-listener"
                         + port        = 80
                         + target_port = 8080
                       },
                   ]
                 + selector = {
                     + app = "mosquitto"
                   }
                 + type     = "LoadBalancer"
               }
           }
       }
     + app_2   = {
         + k8s_pod_autoscaler = {
             + metadata = {
                 + name = "test"
               }
             + spec     = {
                 + max_replicas     = 100
                 + metric           = {
                     + external = {
                         + metric = {
                             + name     = "latency"
                             + selector = {
                                 + match_labels = {
                                     + lb_name = "test"
                                   }
                               }
                           }
                         + target = {
                             + type  = "Value"
                             + value = 100
                           }
                       }
                     + type     = "External"
                   }
                 + min_replicas     = 50
                 + scale_target_ref = {
                     + kind = "Deployment"
                     + name = "MyApp"
                   }
               }
           }
         + pod                = {
             + metadata = {
                 + labels    = {
                     + app = "TestApp"
                   }
                 + name      = "nginx-example"
                 + namespace = null
               }
             + spec     = {
                 + container            = [
                     + {
                         + image          = "nginx:1.7.8"
                         + liveness_probe = {
                             + http_get              = {
                                 + http_header = {
                                     + name  = "X-Custom-Header"
                                     + value = "Awesome"
                                   }
                                 + path        = "/"
                                 + port        = 80
                               }
                             + initial_delay_seconds = 3
                             + period_seconds        = 3
                           }
                         + name           = "nginx-example"
                         + port           = [
                             + {
                                 + container_port = 8080
                               },
                           ]
                       },
                   ]
                 + dns_config           = {
                     + nameservers = [
                         + "1.1.1.1",
                         + "8.8.8.8",
                         + "9.9.9.9",
                       ]
                     + option      = [
                         + {
                             + name  = "ndots"
                             + value = 1
                           },
                         + {
                             + name = "use-vc"
                           },
                       ]
                     + searches    = [
                         + "example.com",
                       ]
                   }
                 + dns_policy           = "None"
                 + env                  = {
                     + name  = "environment"
                     + value = "test"
                   }
                 + secret               = "pod-app-service-account-token-brds5"
                 + service_account_name = "pod-app-service-account"
               }
           }
         + service_account    = {
             + automount_service_account_token = true
             + metadata                        = {
                 + name = "pod-app-service-account"
               }
             + secret                          = [
                 + {
                     + name = "pod-app-secret-file"
                   },
               ]
           }
       }
     + default = {
         + build_dir      = "build"
         + manual_scaling = {
             + instances = 1
           }
         + root_dir       = "mcp"
         + runtime        = "java8"
       }
   }
 + k8s_config_map       = {
     + app_1 = {
         + config_map = {
             + binary_data = {
                 + bar = "L3Jvb3QvMTAw"
               }
             + binary_file = [
                 + "../app_2/resources/binary.bin",
               ]
             + data        = {
                 + test = "test"
               }
             + data_file   = [
                 + "../app_2/resources/mosquitto.conf",
               ]
             + metadata    = {
                 + labels = {
                     + env = "test"
                   }
                 + name   = "mosquitto-config-file"
               }
           }
       }
   }
 + k8s_file             = "../k8s.yml"
 + kubernetes           = {
     + "components" = {
         + common = {
             + name = "name"
           }
         + specs  = {
             + app_1   = {
                 + config_map = {
                     + binary_data = {
                         + bar = "L3Jvb3QvMTAw"
                       }
                     + binary_file = [
                         + "../app_2/resources/binary.bin",
                       ]
                     + data        = {
                         + test = "test"
                       }
                     + data_file   = [
                         + "../app_2/resources/mosquitto.conf",
                       ]
                     + metadata    = {
                         + labels = {
                             + env = "test"
                           }
                         + name   = "mosquitto-config-file"
                       }
                   }
                 + deployment = {
                     + metadata = {
                         + labels    = {
                             + app = "mosquitto"
                           }
                         + name      = "mosquitto"
                         + namespace = null
                       }
                     + spec     = {
                         + replicas = 1
                         + selector = {
                             + match_labels = {
                                 + app = "mosquitto"
                               }
                           }
                         + template = {
                             + metadata = {
                                 + labels = {
                                     + app = "mosquitto"
                                   }
                               }
                             + spec     = {
                                 + container = [
                                     + {
                                         + image        = "eclipse-mosquitto:1.6.2"
                                         + name         = "mosquitto"
                                         + port         = [
                                             + {
                                                 + container_port = 1883
                                               },
                                           ]
                                         + resources    = {
                                             + limits   = {
                                                 + cpu    = "0.5"
                                                 + memory = "512Mi"
                                               }
                                             + requests = {
                                                 + cpu    = "250m"
                                                 + memory = "50Mi"
                                               }
                                           }
                                         + volume_mount = [
                                             + {
                                                 + mount_path = "/mosquitto/secret"
                                                 + name       = "mosquitto-secret-file"
                                               },
                                             + {
                                                 + mount_path = "mosquitto/config"
                                                 + name       = "mosquitto-config-file"
                                               },
                                           ]
                                       },
                                     + {
                                         + image     = "tomcat:8.5-jdk8-adoptopenjdk-openj9"
                                         + name      = "tomcat-example"
                                         + port      = [
                                             + {
                                                 + container_port = 8080
                                               },
                                           ]
                                         + resources = {
                                             + limits   = {
                                                 + cpu    = "0.5"
                                                 + memory = "512Mi"
                                               }
                                             + requests = {
                                                 + cpu    = "250m"
                                                 + memory = "50Mi"
                                               }
                                           }
                                       },
                                   ]
                                 + volume    = [
                                     + {
                                         + config_map = {
                                             + name = "mosquitto-config-file"
                                           }
                                         + name       = "mosquitto-config-file"
                                       },
                                     + {
                                         + name   = "mosquitto-secret-file"
                                         + secret = {
                                             + secret_name = "mosquitto-secret-file"
                                           }
                                       },
                                   ]
                               }
                           }
                       }
                   }
                 + secret     = {
                     + data      = {
                         + login    = "login"
                         + password = "password"
                       }
                     + data_file = [
                         + "../app_2/resources/secret.file",
                       ]
                     + metadata  = {
                         + annotations = {
                             + key1 = null
                             + key2 = null
                           }
                         + labels      = {
                             + env = "test"
                           }
                         + name        = "mosquitto-secret-file"
                         + namespace   = null
                       }
                     + type      = "Opaque"
                   }
                 + service    = {
                     + metadata = {
                         + generate_name = null
                         + labels        = {
                             + env = "test"
                           }
                         + name          = "mosquitto"
                         + namespace     = null
                       }
                     + spec     = {
                         + port     = [
                             + {
                                 + name        = "mosquitto-listener"
                                 + port        = 1883
                                 + target_port = 1883
                               },
                             + {
                                 + name        = "tomcat-listener"
                                 + port        = 80
                                 + target_port = 8080
                               },
                           ]
                         + selector = {
                             + app = "mosquitto"
                           }
                         + type     = "LoadBalancer"
                       }
                   }
               }
             + app_2   = {
                 + k8s_pod_autoscaler = {
                     + metadata = {
                         + name = "test"
                       }
                     + spec     = {
                         + max_replicas     = 100
                         + metric           = {
                             + external = {
                                 + metric = {
                                     + name     = "latency"
                                     + selector = {
                                         + match_labels = {
                                             + lb_name = "test"
                                           }
                                       }
                                   }
                                 + target = {
                                     + type  = "Value"
                                     + value = 100
                                   }
                               }
                             + type     = "External"
                           }
                         + min_replicas     = 50
                         + scale_target_ref = {
                             + kind = "Deployment"
                             + name = "MyApp"
                           }
                       }
                   }
                 + pod                = {
                     + metadata = {
                         + labels    = {
                             + app = "TestApp"
                           }
                         + name      = "nginx-example"
                         + namespace = null
                       }
                     + spec     = {
                         + container            = [
                             + {
                                 + image          = "nginx:1.7.8"
                                 + liveness_probe = {
                                     + http_get              = {
                                         + http_header = {
                                             + name  = "X-Custom-Header"
                                             + value = "Awesome"
                                           }
                                         + path        = "/"
                                         + port        = 80
                                       }
                                     + initial_delay_seconds = 3
                                     + period_seconds        = 3
                                   }
                                 + name           = "nginx-example"
                                 + port           = [
                                     + {
                                         + container_port = 8080
                                       },
                                   ]
                               },
                           ]
                         + dns_config           = {
                             + nameservers = [
                                 + "1.1.1.1",
                                 + "8.8.8.8",
                                 + "9.9.9.9",
                               ]
                             + option      = [
                                 + {
                                     + name  = "ndots"
                                     + value = 1
                                   },
                                 + {
                                     + name = "use-vc"
                                   },
                               ]
                             + searches    = [
                                 + "example.com",
                               ]
                           }
                         + dns_policy           = "None"
                         + env                  = {
                             + name  = "environment"
                             + value = "test"
                           }
                         + secret               = "pod-app-service-account-token-brds5"
                         + service_account_name = "pod-app-service-account"
                       }
                   }
                 + service_account    = {
                     + automount_service_account_token = true
                     + metadata                        = {
                         + name = "pod-app-service-account"
                       }
                     + secret                          = [
                         + {
                             + name = "pod-app-secret-file"
                           },
                       ]
                   }
               }
             + default = {
                 + build_dir      = "build"
                 + manual_scaling = {
                     + instances = 1
                   }
                 + root_dir       = "mcp"
                 + runtime        = "java8"
               }
           }
       }
   }

Do you want to perform these actions?
 Terraform will perform the actions described above.
 Only 'yes' will be accepted to approve.

 Enter a value: no

Apply cancelled.
✘ dmitrogavrichuk@iMac-Dmitro  ~/DEVOPS/Mesoform/global_structure_test/terraform 

#************************************************************
# Here I removes all terraform files from terraform directory
#************************************************************

✘ dmitrogavrichuk@iMac-Dmitro  ~/DEVOPS/Mesoform/global_structure_test/terraform  terraform init
Initializing modules...
- mcp in ../mcp

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/kubernetes...
- Finding latest version of hashicorp/google...
- Finding latest version of hashicorp/google-beta...
- Installing hashicorp/kubernetes v1.13.3...
- Installed hashicorp/kubernetes v1.13.3 (signed by HashiCorp)
- Installing hashicorp/google v3.49.0...
- Installed hashicorp/google v3.49.0 (signed by HashiCorp)
- Installing hashicorp/google-beta v3.49.0...
- Installed hashicorp/google-beta v3.49.0 (signed by HashiCorp)

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, we recommend adding version constraints in a required_providers block
in your configuration, with the constraint strings suggested below.

* hashicorp/google: version = "~> 3.49.0"
* hashicorp/google-beta: version = "~> 3.49.0"
* hashicorp/kubernetes: version = "~> 1.13.3"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
dmitrogavrichuk@iMac-Dmitro  ~/DEVOPS/Mesoform/global_structure_test/terraform 
dmitrogavrichuk@iMac-Dmitro  ~/DEVOPS/Mesoform/global_structure_test/terraform  terraform apply
module.mcp.data.google_project.default[0]: Refreshing state...
module.mcp.data.google_project.self[0]: Refreshing state...
module.mcp.data.google_iam_policy.auth["default"]: Refreshing state...
module.mcp.data.google_iam_policy.noauth["default"]: Refreshing state...

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
 + create

Terraform will perform the following actions:

 # module.mcp.google_app_engine_application.self[0] will be created
 + resource "google_app_engine_application" "self" {
     + app_id            = (known after apply)
     + auth_domain       = (known after apply)
     + code_bucket       = (known after apply)
     + database_type     = (known after apply)
     + default_bucket    = (known after apply)
     + default_hostname  = (known after apply)
     + gcr_domain        = (known after apply)
     + id                = (known after apply)
     + location_id       = "europe-west2"
     + name              = (known after apply)
     + project           = "global-cluster-2"
     + serving_status    = (known after apply)
     + url_dispatch_rule = (known after apply)

     + feature_settings {
         + split_health_checks = (known after apply)
       }

     + iap {
         + enabled                     = (known after apply)
         + oauth2_client_id            = (known after apply)
         + oauth2_client_secret        = (sensitive value)
         + oauth2_client_secret_sha256 = (sensitive value)
       }
   }

 # module.mcp.google_app_engine_standard_app_version.self["default"] will be created
 + resource "google_app_engine_standard_app_version" "self" {
     + delete_service_on_destroy = false
     + env_variables             = {
         + "GCP_PROJECT_ID" = "global-cluster-2"
       }
     + id                        = (known after apply)
     + instance_class            = (known after apply)
     + name                      = (known after apply)
     + noop_on_destroy           = false
     + project                   = "global-cluster-2"
     + runtime                   = "python37"
     + service                   = "default"
     + version_id                = "1"

     + deployment {
         + files {
             + name       = "main.py"
             + sha1_sum   = "6bcd5ab8b7d46f59780ba2497c112294220aa0cb"
             + source_url = "https://storage.googleapis.com/global-cluster-2/6bcd5ab8b7d46f59780ba2497c112294220aa0cb"
           }
         + files {
             + name       = "requirements.txt"
             + sha1_sum   = "570b1896080f7368d7a8737d020cfe252416d2c9"
             + source_url = "https://storage.googleapis.com/global-cluster-2/570b1896080f7368d7a8737d020cfe252416d2c9"
           }
       }

     + entrypoint {
         + shell = "python main.py"
       }

     + handlers {
         + auth_fail_action            = (known after apply)
         + login                       = (known after apply)
         + redirect_http_response_code = (known after apply)
         + security_level              = (known after apply)
         + url_regex                   = (known after apply)

         + script {
             + script_path = (known after apply)
           }

         + static_files {
             + application_readable  = (known after apply)
             + expiration            = (known after apply)
             + http_headers          = (known after apply)
             + mime_type             = (known after apply)
             + path                  = (known after apply)
             + require_matching_file = (known after apply)
             + upload_path_regex     = (known after apply)
           }
       }
   }

 # module.mcp.google_cloud_run_service.self["default"] will be created
 + resource "google_cloud_run_service" "self" {
     + autogenerate_revision_name = false
     + id                         = (known after apply)
     + location                   = "europe-west2"
     + name                       = "default"
     + project                    = "global-cluster-2"
     + status                     = (known after apply)

     + metadata {
         + annotations      = (known after apply)
         + generation       = (known after apply)
         + labels           = (known after apply)
         + namespace        = (known after apply)
         + resource_version = (known after apply)
         + self_link        = (known after apply)
         + uid              = (known after apply)
       }

     + template {
         + metadata {
             + annotations      = {
                 + "autoscaling.knative.dev/maxScale" = "1000"
                 + "run.googleapis.com/client-name"   = "terraform"
               }
             + generation       = (known after apply)
             + name             = (known after apply)
             + namespace        = (known after apply)
             + resource_version = (known after apply)
             + self_link        = (known after apply)
             + uid              = (known after apply)
           }

         + spec {
             + container_concurrency = (known after apply)
             + serving_state         = (known after apply)
             + timeout_seconds       = (known after apply)

             + containers {
                 + image = "gcr.io/global-cluster-2/helloworld"

                 + ports {
                     + container_port = (known after apply)
                     + name           = (known after apply)
                     + protocol       = (known after apply)
                   }

                 + resources {
                     + limits   = (known after apply)
                     + requests = (known after apply)
                   }
               }
           }
       }

     + traffic {
         + latest_revision = (known after apply)
         + percent         = (known after apply)
         + revision_name   = (known after apply)
       }
   }

 # module.mcp.google_cloud_run_service_iam_policy.self["default"] will be created
 + resource "google_cloud_run_service_iam_policy" "self" {
     + etag        = (known after apply)
     + id          = (known after apply)
     + location    = "europe-west2"
     + policy_data = jsonencode(
           {
             + bindings = [
                 + {
                     + members = [
                         + "allUsers",
                       ]
                     + role    = "roles/run.invoker"
                   },
               ]
           }
       )
     + project     = "global-cluster-2"
     + service     = "default"
   }

 # module.mcp.google_project_service.cloudrun[0] will be created
 + resource "google_project_service" "cloudrun" {
     + disable_dependent_services = true
     + disable_on_destroy         = true
     + id                         = (known after apply)
     + project                    = "global-cluster-2"
     + service                    = "run.googleapis.com"
   }

 # module.mcp.google_project_service.iam[0] will be created
 + resource "google_project_service" "iam" {
     + disable_on_destroy = false
     + id                 = (known after apply)
     + project            = "global-cluster-2"
     + service            = "iam.googleapis.com"
   }

 # module.mcp.google_project_service.std[0] will be created
 + resource "google_project_service" "std" {
     + disable_dependent_services = true
     + disable_on_destroy         = true
     + id                         = (known after apply)
     + project                    = "global-cluster-2"
     + service                    = "appengine.googleapis.com"
   }

 # module.mcp.google_storage_bucket.self[0] will be created
 + resource "google_storage_bucket" "self" {
     + bucket_policy_only          = (known after apply)
     + default_event_based_hold    = false
     + force_destroy               = true
     + id                          = (known after apply)
     + labels                      = {
         + "billing" = "central"
       }
     + location                    = "EUROPE-WEST2"
     + name                        = "global-cluster-2"
     + project                     = "global-cluster-2"
     + requester_pays              = false
     + self_link                   = (known after apply)
     + storage_class               = "REGIONAL"
     + uniform_bucket_level_access = true
     + url                         = (known after apply)

     + versioning {
         + enabled = true
       }
   }

 # module.mcp.google_storage_bucket_object.self["../app_1/build/helloworld/main.py"] will be created
 + resource "google_storage_bucket_object" "self" {
     + bucket         = "global-cluster-2"
     + content_type   = (known after apply)
     + crc32c         = (known after apply)
     + detect_md5hash = "different hash"
     + id             = (known after apply)
     + md5hash        = (known after apply)
     + media_link     = (known after apply)
     + name           = "6bcd5ab8b7d46f59780ba2497c112294220aa0cb"
     + output_name    = (known after apply)
     + self_link      = (known after apply)
     + source         = "../app_1/build/helloworld/main.py"
     + storage_class  = (known after apply)
   }

 # module.mcp.google_storage_bucket_object.self["../app_1/build/helloworld/requirements.txt"] will be created
 + resource "google_storage_bucket_object" "self" {
     + bucket         = "global-cluster-2"
     + content_type   = (known after apply)
     + crc32c         = (known after apply)
     + detect_md5hash = "different hash"
     + id             = (known after apply)
     + md5hash        = (known after apply)
     + media_link     = (known after apply)
     + name           = "570b1896080f7368d7a8737d020cfe252416d2c9"
     + output_name    = (known after apply)
     + self_link      = (known after apply)
     + source         = "../app_1/build/helloworld/requirements.txt"
     + storage_class  = (known after apply)
   }

 # module.mcp.kubernetes_config_map.self["app_1"] will be created
 + resource "kubernetes_config_map" "self" {
     + binary_data = {
         + "bar"        = "L3Jvb3QvMTAw"
         + "binary.bin" = "SGVsbG8gV29ybGQ="
       }
     + data        = {
         + "mosquitto.conf" = <<~EOT
               log_dest stdout
               log_type all
               log_timestamp true
               listener 9001
           EOT
         + "test"           = "test"
       }
     + id          = (known after apply)

     + metadata {
         + generation       = (known after apply)
         + labels           = {
             + "env" = "test"
           }
         + name             = "mosquitto-config-file"
         + namespace        = "default"
         + resource_version = (known after apply)
         + self_link        = (known after apply)
         + uid              = (known after apply)
       }
   }

 # module.mcp.kubernetes_deployment.self["app_1"] will be created
 + resource "kubernetes_deployment" "self" {
     + id               = (known after apply)
     + wait_for_rollout = true

     + metadata {
         + generation       = (known after apply)
         + labels           = {
             + "app" = "mosquitto"
           }
         + name             = "mosquitto"
         + namespace        = "default"
         + resource_version = (known after apply)
         + self_link        = (known after apply)
         + uid              = (known after apply)
       }

     + spec {
         + min_ready_seconds         = 0
         + paused                    = false
         + progress_deadline_seconds = 600
         + replicas                  = 1
         + revision_history_limit    = 10

         + selector {
             + match_labels = {
                 + "app" = "mosquitto"
               }
           }

         + strategy {
             + type = (known after apply)

             + rolling_update {
                 + max_surge       = (known after apply)
                 + max_unavailable = (known after apply)
               }
           }

         + template {
             + metadata {
                 + generation       = (known after apply)
                 + labels           = {
                     + "app" = "mosquitto"
                   }
                 + name             = (known after apply)
                 + resource_version = (known after apply)
                 + self_link        = (known after apply)
                 + uid              = (known after apply)
               }

             + spec {
                 + dns_policy                       = "ClusterFirst"
                 + enable_service_links             = true
                 + host_ipc                         = false
                 + host_network                     = false
                 + host_pid                         = false
                 + hostname                         = (known after apply)
                 + node_name                        = (known after apply)
                 + restart_policy                   = "Always"
                 + service_account_name             = (known after apply)
                 + share_process_namespace          = false
                 + termination_grace_period_seconds = 30

                 + container {
                     + image                      = "eclipse-mosquitto:1.6.2"
                     + image_pull_policy          = (known after apply)
                     + name                       = "mosquitto"
                     + stdin                      = false
                     + stdin_once                 = false
                     + termination_message_path   = "/dev/termination-log"
                     + termination_message_policy = (known after apply)
                     + tty                        = false

                     + port {
                         + container_port = 1883
                         + protocol       = "TCP"
                       }

                     + resources {
                         + limits {
                             + cpu    = "0.5"
                             + memory = "512Mi"
                           }

                         + requests {
                             + cpu    = "250m"
                             + memory = "50Mi"
                           }
                       }

                     + volume_mount {
                         + mount_path        = "/mosquitto/secret"
                         + mount_propagation = "None"
                         + name              = "mosquitto-secret-file"
                         + read_only         = false
                       }
                     + volume_mount {
                         + mount_path        = "mosquitto/config"
                         + mount_propagation = "None"
                         + name              = "mosquitto-config-file"
                         + read_only         = false
                       }
                   }
                 + container {
                     + image                      = "tomcat:8.5-jdk8-adoptopenjdk-openj9"
                     + image_pull_policy          = (known after apply)
                     + name                       = "tomcat-example"
                     + stdin                      = false
                     + stdin_once                 = false
                     + termination_message_path   = "/dev/termination-log"
                     + termination_message_policy = (known after apply)
                     + tty                        = false

                     + port {
                         + container_port = 8080
                         + protocol       = "TCP"
                       }

                     + resources {
                         + limits {
                             + cpu    = "0.5"
                             + memory = "512Mi"
                           }

                         + requests {
                             + cpu    = "250m"
                             + memory = "50Mi"
                           }
                       }

                     + volume_mount {
                         + mount_path        = (known after apply)
                         + mount_propagation = (known after apply)
                         + name              = (known after apply)
                         + read_only         = (known after apply)
                         + sub_path          = (known after apply)
                       }
                   }

                 + image_pull_secrets {
                     + name = (known after apply)
                   }

                 + volume {
                     + name = "mosquitto-config-file"

                     + config_map {
                         + default_mode = "0644"
                         + name         = "mosquitto-config-file"
                       }
                   }
                 + volume {
                     + name = "mosquitto-secret-file"

                     + secret {
                         + default_mode = "0644"
                         + secret_name  = "mosquitto-secret-file"
                       }
                   }
               }
           }
       }
   }

 # module.mcp.kubernetes_pod.self["app_2"] will be created
 + resource "kubernetes_pod" "self" {
     + id = (known after apply)

     + metadata {
         + generation       = (known after apply)
         + labels           = {
             + "app" = "TestApp"
           }
         + name             = "nginx-example"
         + namespace        = "default"
         + resource_version = (known after apply)
         + self_link        = (known after apply)
         + uid              = (known after apply)
       }

     + spec {
         + automount_service_account_token  = false
         + dns_policy                       = "None"
         + enable_service_links             = true
         + host_ipc                         = false
         + host_network                     = false
         + host_pid                         = false
         + hostname                         = (known after apply)
         + node_name                        = (known after apply)
         + restart_policy                   = "Always"
         + service_account_name             = "pod-app-service-account"
         + share_process_namespace          = false
         + termination_grace_period_seconds = 30

         + container {
             + image                      = "nginx:1.7.8"
             + image_pull_policy          = (known after apply)
             + name                       = "nginx-example"
             + stdin                      = false
             + stdin_once                 = false
             + termination_message_path   = "/dev/termination-log"
             + termination_message_policy = (known after apply)
             + tty                        = false

             + liveness_probe {
                 + failure_threshold     = 3
                 + initial_delay_seconds = 3
                 + period_seconds        = 3
                 + success_threshold     = 1
                 + timeout_seconds       = 1

                 + http_get {
                     + path   = "/"
                     + port   = "80"
                     + scheme = "HTTP"

                     + http_header {
                         + name  = "X-Custom-Header"
                         + value = "Awesome"
                       }
                   }
               }

             + port {
                 + container_port = 8080
                 + protocol       = "TCP"
               }

             + resources {
                 + limits {
                     + cpu    = (known after apply)
                     + memory = (known after apply)
                   }

                 + requests {
                     + cpu    = (known after apply)
                     + memory = (known after apply)
                   }
               }

             + volume_mount {
                 + mount_path        = (known after apply)
                 + mount_propagation = (known after apply)
                 + name              = (known after apply)
                 + read_only         = (known after apply)
                 + sub_path          = (known after apply)
               }
           }

         + dns_config {
             + nameservers = [
                 + "1.1.1.1",
                 + "8.8.8.8",
                 + "9.9.9.9",
               ]
             + searches    = [
                 + "example.com",
               ]

             + option {
                 + name  = "ndots"
                 + value = "1"
               }
             + option {
                 + name = "use-vc"
               }
           }

         + image_pull_secrets {
             + name = (known after apply)
           }

         + volume {
             + name = (known after apply)

             + aws_elastic_block_store {
                 + fs_type   = (known after apply)
                 + partition = (known after apply)
                 + read_only = (known after apply)
                 + volume_id = (known after apply)
               }

             + azure_disk {
                 + caching_mode  = (known after apply)
                 + data_disk_uri = (known after apply)
                 + disk_name     = (known after apply)
                 + fs_type       = (known after apply)
                 + kind          = (known after apply)
                 + read_only     = (known after apply)
               }

             + azure_file {
                 + read_only   = (known after apply)
                 + secret_name = (known after apply)
                 + share_name  = (known after apply)
               }

             + ceph_fs {
                 + monitors    = (known after apply)
                 + path        = (known after apply)
                 + read_only   = (known after apply)
                 + secret_file = (known after apply)
                 + user        = (known after apply)

                 + secret_ref {
                     + name      = (known after apply)
                     + namespace = (known after apply)
                   }
               }

             + cinder {
                 + fs_type   = (known after apply)
                 + read_only = (known after apply)
                 + volume_id = (known after apply)
               }

             + config_map {
                 + default_mode = (known after apply)
                 + name         = (known after apply)
                 + optional     = (known after apply)

                 + items {
                     + key  = (known after apply)
                     + mode = (known after apply)
                     + path = (known after apply)
                   }
               }

             + csi {
                 + driver            = (known after apply)
                 + fs_type           = (known after apply)
                 + read_only         = (known after apply)
                 + volume_attributes = (known after apply)
                 + volume_handle     = (known after apply)

                 + controller_expand_secret_ref {
                     + name      = (known after apply)
                     + namespace = (known after apply)
                   }

                 + controller_publish_secret_ref {
                     + name      = (known after apply)
                     + namespace = (known after apply)
                   }

                 + node_publish_secret_ref {
                     + name      = (known after apply)
                     + namespace = (known after apply)
                   }

                 + node_stage_secret_ref {
                     + name      = (known after apply)
                     + namespace = (known after apply)
                   }
               }

             + downward_api {
                 + default_mode = (known after apply)

                 + items {
                     + mode = (known after apply)
                     + path = (known after apply)

                     + field_ref {
                         + api_version = (known after apply)
                         + field_path  = (known after apply)
                       }

                     + resource_field_ref {
                         + container_name = (known after apply)
                         + quantity       = (known after apply)
                         + resource       = (known after apply)
                       }
                   }
               }

             + empty_dir {
                 + medium     = (known after apply)
                 + size_limit = (known after apply)
               }

             + fc {
                 + fs_type      = (known after apply)
                 + lun          = (known after apply)
                 + read_only    = (known after apply)
                 + target_ww_ns = (known after apply)
               }

             + flex_volume {
                 + driver    = (known after apply)
                 + fs_type   = (known after apply)
                 + options   = (known after apply)
                 + read_only = (known after apply)

                 + secret_ref {
                     + name      = (known after apply)
                     + namespace = (known after apply)
                   }
               }

             + flocker {
                 + dataset_name = (known after apply)
                 + dataset_uuid = (known after apply)
               }

             + gce_persistent_disk {
                 + fs_type   = (known after apply)
                 + partition = (known after apply)
                 + pd_name   = (known after apply)
                 + read_only = (known after apply)
               }

             + git_repo {
                 + directory  = (known after apply)
                 + repository = (known after apply)
                 + revision   = (known after apply)
               }

             + glusterfs {
                 + endpoints_name = (known after apply)
                 + path           = (known after apply)
                 + read_only      = (known after apply)
               }

             + host_path {
                 + path = (known after apply)
                 + type = (known after apply)
               }

             + iscsi {
                 + fs_type         = (known after apply)
                 + iqn             = (known after apply)
                 + iscsi_interface = (known after apply)
                 + lun             = (known after apply)
                 + read_only       = (known after apply)
                 + target_portal   = (known after apply)
               }

             + local {
                 + path = (known after apply)
               }

             + nfs {
                 + path      = (known after apply)
                 + read_only = (known after apply)
                 + server    = (known after apply)
               }

             + persistent_volume_claim {
                 + claim_name = (known after apply)
                 + read_only  = (known after apply)
               }

             + photon_persistent_disk {
                 + fs_type = (known after apply)
                 + pd_id   = (known after apply)
               }

             + projected {
                 + default_mode = (known after apply)

                 + sources {
                     + config_map {
                         + name     = (known after apply)
                         + optional = (known after apply)

                         + items {
                             + key  = (known after apply)
                             + mode = (known after apply)
                             + path = (known after apply)
                           }
                       }

                     + downward_api {
                         + items {
                             + mode = (known after apply)
                             + path = (known after apply)

                             + field_ref {
                                 + api_version = (known after apply)
                                 + field_path  = (known after apply)
                               }

                             + resource_field_ref {
                                 + container_name = (known after apply)
                                 + quantity       = (known after apply)
                                 + resource       = (known after apply)
                               }
                           }
                       }

                     + secret {
                         + name     = (known after apply)
                         + optional = (known after apply)

                         + items {
                             + key  = (known after apply)
                             + mode = (known after apply)
                             + path = (known after apply)
                           }
                       }

                     + service_account_token {
                         + audience           = (known after apply)
                         + expiration_seconds = (known after apply)
                         + path               = (known after apply)
                       }
                   }
               }

             + quobyte {
                 + group     = (known after apply)
                 + read_only = (known after apply)
                 + registry  = (known after apply)
                 + user      = (known after apply)
                 + volume    = (known after apply)
               }

             + rbd {
                 + ceph_monitors = (known after apply)
                 + fs_type       = (known after apply)
                 + keyring       = (known after apply)
                 + rados_user    = (known after apply)
                 + rbd_image     = (known after apply)
                 + rbd_pool      = (known after apply)
                 + read_only     = (known after apply)

                 + secret_ref {
                     + name      = (known after apply)
                     + namespace = (known after apply)
                   }
               }

             + secret {
                 + default_mode = (known after apply)
                 + optional     = (known after apply)
                 + secret_name  = (known after apply)

                 + items {
                     + key  = (known after apply)
                     + mode = (known after apply)
                     + path = (known after apply)
                   }
               }

             + vsphere_volume {
                 + fs_type     = (known after apply)
                 + volume_path = (known after apply)
               }
           }
       }
   }

 # module.mcp.kubernetes_secret.self["app_1"] will be created
 + resource "kubernetes_secret" "self" {
     + data = (sensitive value)
     + id   = (known after apply)
     + type = "Opaque"

     + metadata {
         + generation       = (known after apply)
         + labels           = {
             + "env" = "test"
           }
         + name             = "mosquitto-secret-file"
         + namespace        = "default"
         + resource_version = (known after apply)
         + self_link        = (known after apply)
         + uid              = (known after apply)
       }
   }

 # module.mcp.kubernetes_service.self["app_1"] will be created
 + resource "kubernetes_service" "self" {
     + id                    = (known after apply)
     + load_balancer_ingress = (known after apply)

     + metadata {
         + generation       = (known after apply)
         + labels           = {
             + "env" = "test"
           }
         + name             = "mosquitto"
         + namespace        = "default"
         + resource_version = (known after apply)
         + self_link        = (known after apply)
         + uid              = (known after apply)
       }

     + spec {
         + cluster_ip                  = (known after apply)
         + external_traffic_policy     = (known after apply)
         + health_check_node_port      = (known after apply)
         + publish_not_ready_addresses = false
         + selector                    = {
             + "app" = "mosquitto"
           }
         + session_affinity            = "None"
         + type                        = "LoadBalancer"

         + port {
             + name        = "mosquitto-listener"
             + node_port   = (known after apply)
             + port        = 1883
             + protocol    = "TCP"
             + target_port = "1883"
           }
         + port {
             + name        = "tomcat-listener"
             + node_port   = (known after apply)
             + port        = 80
             + protocol    = "TCP"
             + target_port = "8080"
           }
       }
   }

 # module.mcp.kubernetes_service_account.self["app_2"] will be created
 + resource "kubernetes_service_account" "self" {
     + automount_service_account_token = false
     + default_secret_name             = (known after apply)
     + id                              = (known after apply)

     + metadata {
         + generation       = (known after apply)
         + name             = "pod-app-service-account"
         + namespace        = "default"
         + resource_version = (known after apply)
         + self_link        = (known after apply)
         + uid              = (known after apply)
       }

     + secret {
         + name = "pod-app-secret-file"
       }
   }

Plan: 16 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
 Terraform will perform the actions described above.
 Only 'yes' will be accepted to approve.

 Enter a value: yes

module.mcp.google_project_service.cloudrun[0]: Creating...
module.mcp.google_storage_bucket.self[0]: Creating...
module.mcp.google_project_service.std[0]: Creating...
module.mcp.google_project_service.iam[0]: Creating...
module.mcp.kubernetes_secret.self["app_1"]: Creating...
module.mcp.kubernetes_service_account.self["app_2"]: Creating...
module.mcp.kubernetes_config_map.self["app_1"]: Creating...
module.mcp.kubernetes_service.self["app_1"]: Creating...
module.mcp.kubernetes_pod.self["app_2"]: Creating...
module.mcp.kubernetes_deployment.self["app_1"]: Creating...
module.mcp.google_storage_bucket.self[0]: Creation complete after 2s [id=global-cluster-2]
module.mcp.google_storage_bucket_object.self["../app_1/build/helloworld/main.py"]: Creating...
module.mcp.google_storage_bucket_object.self["../app_1/build/helloworld/main.py"]: Creation complete after 0s [id=global-cluster-2-6bcd5ab8b7d46f59780ba2497c112294220aa0cb]
module.mcp.google_storage_bucket_object.self["../app_1/build/helloworld/requirements.txt"]: Creating...
module.mcp.google_storage_bucket_object.self["../app_1/build/helloworld/requirements.txt"]: Creation complete after 1s [id=global-cluster-2-570b1896080f7368d7a8737d020cfe252416d2c9]
module.mcp.kubernetes_secret.self["app_1"]: Creation complete after 3s [id=default/mosquitto-secret-file]
module.mcp.kubernetes_config_map.self["app_1"]: Creation complete after 3s [id=default/mosquitto-config-file]
module.mcp.kubernetes_service_account.self["app_2"]: Creation complete after 3s [id=default/pod-app-service-account]
module.mcp.google_project_service.iam[0]: Creation complete after 4s [id=global-cluster-2/iam.googleapis.com]
module.mcp.google_project_service.std[0]: Still creating... [10s elapsed]
module.mcp.google_project_service.cloudrun[0]: Still creating... [10s elapsed]
module.mcp.kubernetes_service.self["app_1"]: Still creating... [10s elapsed]
module.mcp.kubernetes_pod.self["app_2"]: Still creating... [10s elapsed]
module.mcp.kubernetes_deployment.self["app_1"]: Still creating... [10s elapsed]
module.mcp.kubernetes_pod.self["app_2"]: Creation complete after 16s [id=default/nginx-example]
module.mcp.google_project_service.cloudrun[0]: Still creating... [20s elapsed]
module.mcp.google_project_service.std[0]: Still creating... [20s elapsed]
module.mcp.kubernetes_service.self["app_1"]: Still creating... [20s elapsed]
module.mcp.kubernetes_deployment.self["app_1"]: Still creating... [20s elapsed]
module.mcp.google_project_service.cloudrun[0]: Creation complete after 26s [id=global-cluster-2/run.googleapis.com]
module.mcp.google_project_service.std[0]: Creation complete after 26s [id=global-cluster-2/appengine.googleapis.com]
module.mcp.google_app_engine_application.self[0]: Creating...
module.mcp.google_app_engine_standard_app_version.self["default"]: Creating...
module.mcp.google_cloud_run_service.self["default"]: Creating...
module.mcp.kubernetes_deployment.self["app_1"]: Creation complete after 29s [id=default/mosquitto]
module.mcp.kubernetes_service.self["app_1"]: Still creating... [30s elapsed]
module.mcp.google_app_engine_application.self[0]: Still creating... [10s elapsed]
module.mcp.google_app_engine_standard_app_version.self["default"]: Still creating... [10s elapsed]
module.mcp.google_cloud_run_service.self["default"]: Still creating... [10s elapsed]
module.mcp.google_app_engine_application.self[0]: Creation complete after 12s [id=global-cluster-2]
module.mcp.kubernetes_service.self["app_1"]: Still creating... [40s elapsed]
module.mcp.google_app_engine_standard_app_version.self["default"]: Still creating... [20s elapsed]
module.mcp.google_cloud_run_service.self["default"]: Still creating... [20s elapsed]
module.mcp.kubernetes_service.self["app_1"]: Creation complete after 49s [id=default/mosquitto]
module.mcp.google_app_engine_standard_app_version.self["default"]: Still creating... [30s elapsed]
module.mcp.google_cloud_run_service.self["default"]: Still creating... [30s elapsed]
module.mcp.google_app_engine_standard_app_version.self["default"]: Still creating... [40s elapsed]
module.mcp.google_cloud_run_service.self["default"]: Still creating... [40s elapsed]
module.mcp.google_app_engine_standard_app_version.self["default"]: Still creating... [50s elapsed]
module.mcp.google_cloud_run_service.self["default"]: Still creating... [50s elapsed]
module.mcp.google_app_engine_standard_app_version.self["default"]: Still creating... [1m0s elapsed]
module.mcp.google_cloud_run_service.self["default"]: Still creating... [1m0s elapsed]
module.mcp.google_cloud_run_service.self["default"]: Still creating... [1m10s elapsed]
module.mcp.google_app_engine_standard_app_version.self["default"]: Still creating... [1m10s elapsed]
module.mcp.google_app_engine_standard_app_version.self["default"]: Still creating... [1m20s elapsed]
module.mcp.google_cloud_run_service.self["default"]: Still creating... [1m20s elapsed]
module.mcp.google_app_engine_standard_app_version.self["default"]: Creation complete after 1m26s [id=apps/global-cluster-2/services/default/versions/1]
module.mcp.google_cloud_run_service.self["default"]: Still creating... [1m30s elapsed]
module.mcp.google_cloud_run_service.self["default"]: Still creating... [1m40s elapsed]
module.mcp.google_cloud_run_service.self["default"]: Still creating... [1m50s elapsed]
module.mcp.google_cloud_run_service.self["default"]: Creation complete after 1m51s [id=locations/europe-west2/namespaces/global-cluster-2/services/default]
module.mcp.google_cloud_run_service_iam_policy.self["default"]: Creating...
module.mcp.google_cloud_run_service_iam_policy.self["default"]: Creation complete after 1s [id=v1/projects/global-cluster-2/locations/europe-west2/services/default]

Apply complete! Resources: 16 added, 0 changed, 0 destroyed.

Outputs:

k8s_components = {
 "common" = {
   "name" = "name"
 }
 "specs" = {
   "app_1" = {
     "config_map" = {
       "binary_data" = {
         "bar" = "L3Jvb3QvMTAw"
       }
       "binary_file" = [
         "../app_2/resources/binary.bin",
       ]
       "data" = {
         "test" = "test"
       }
       "data_file" = [
         "../app_2/resources/mosquitto.conf",
       ]
       "metadata" = {
         "labels" = {
           "env" = "test"
         }
         "name" = "mosquitto-config-file"
       }
     }
     "deployment" = {
       "metadata" = {
         "labels" = {
           "app" = "mosquitto"
         }
         "name" = "mosquitto"
       }
       "spec" = {
         "replicas" = 1
         "selector" = {
           "match_labels" = {
             "app" = "mosquitto"
           }
         }
         "template" = {
           "metadata" = {
             "labels" = {
               "app" = "mosquitto"
             }
           }
           "spec" = {
             "container" = [
               {
                 "image" = "eclipse-mosquitto:1.6.2"
                 "name" = "mosquitto"
                 "port" = [
                   {
                     "container_port" = 1883
                   },
                 ]
                 "resources" = {
                   "limits" = {
                     "cpu" = "0.5"
                     "memory" = "512Mi"
                   }
                   "requests" = {
                     "cpu" = "250m"
                     "memory" = "50Mi"
                   }
                 }
                 "volume_mount" = [
                   {
                     "mount_path" = "/mosquitto/secret"
                     "name" = "mosquitto-secret-file"
                   },
                   {
                     "mount_path" = "mosquitto/config"
                     "name" = "mosquitto-config-file"
                   },
                 ]
               },
               {
                 "image" = "tomcat:8.5-jdk8-adoptopenjdk-openj9"
                 "name" = "tomcat-example"
                 "port" = [
                   {
                     "container_port" = 8080
                   },
                 ]
                 "resources" = {
                   "limits" = {
                     "cpu" = "0.5"
                     "memory" = "512Mi"
                   }
                   "requests" = {
                     "cpu" = "250m"
                     "memory" = "50Mi"
                   }
                 }
               },
             ]
             "volume" = [
               {
                 "config_map" = {
                   "name" = "mosquitto-config-file"
                 }
                 "name" = "mosquitto-config-file"
               },
               {
                 "name" = "mosquitto-secret-file"
                 "secret" = {
                   "secret_name" = "mosquitto-secret-file"
                 }
               },
             ]
           }
         }
       }
     }
     "secret" = {
       "data" = {
         "login" = "login"
         "password" = "password"
       }
       "data_file" = [
         "../app_2/resources/secret.file",
       ]
       "metadata" = {
         "annotations" = {}
         "labels" = {
           "env" = "test"
         }
         "name" = "mosquitto-secret-file"
       }
       "type" = "Opaque"
     }
     "service" = {
       "metadata" = {
         "labels" = {
           "env" = "test"
         }
         "name" = "mosquitto"
       }
       "spec" = {
         "port" = [
           {
             "name" = "mosquitto-listener"
             "port" = 1883
             "target_port" = 1883
           },
           {
             "name" = "tomcat-listener"
             "port" = 80
             "target_port" = 8080
           },
         ]
         "selector" = {
           "app" = "mosquitto"
         }
         "type" = "LoadBalancer"
       }
     }
   }
   "app_2" = {
     "k8s_pod_autoscaler" = {
       "metadata" = {
         "name" = "test"
       }
       "spec" = {
         "max_replicas" = 100
         "metric" = {
           "external" = {
             "metric" = {
               "name" = "latency"
               "selector" = {
                 "match_labels" = {
                   "lb_name" = "test"
                 }
               }
             }
             "target" = {
               "type" = "Value"
               "value" = 100
             }
           }
           "type" = "External"
         }
         "min_replicas" = 50
         "scale_target_ref" = {
           "kind" = "Deployment"
           "name" = "MyApp"
         }
       }
     }
     "pod" = {
       "metadata" = {
         "labels" = {
           "app" = "TestApp"
         }
         "name" = "nginx-example"
       }
       "spec" = {
         "container" = [
           {
             "image" = "nginx:1.7.8"
             "liveness_probe" = {
               "http_get" = {
                 "http_header" = {
                   "name" = "X-Custom-Header"
                   "value" = "Awesome"
                 }
                 "path" = "/"
                 "port" = 80
               }
               "initial_delay_seconds" = 3
               "period_seconds" = 3
             }
             "name" = "nginx-example"
             "port" = [
               {
                 "container_port" = 8080
               },
             ]
           },
         ]
         "dns_config" = {
           "nameservers" = [
             "1.1.1.1",
             "8.8.8.8",
             "9.9.9.9",
           ]
           "option" = [
             {
               "name" = "ndots"
               "value" = 1
             },
             {
               "name" = "use-vc"
             },
           ]
           "searches" = [
             "example.com",
           ]
         }
         "dns_policy" = "None"
         "env" = {
           "name" = "environment"
           "value" = "test"
         }
         "secret" = "pod-app-service-account-token-brds5"
         "service_account_name" = "pod-app-service-account"
       }
     }
     "service_account" = {
       "automount_service_account_token" = true
       "metadata" = {
         "name" = "pod-app-service-account"
       }
       "secret" = [
         {
           "name" = "pod-app-secret-file"
         },
       ]
     }
   }
   "default" = {
     "build_dir" = "build"
     "manual_scaling" = {
       "instances" = 1
     }
     "root_dir" = "mcp"
     "runtime" = "java8"
   }
 }
}
k8s_components_specs = {
 "app_1" = {
   "config_map" = {
     "binary_data" = {
       "bar" = "L3Jvb3QvMTAw"
     }
     "binary_file" = [
       "../app_2/resources/binary.bin",
     ]
     "data" = {
       "test" = "test"
     }
     "data_file" = [
       "../app_2/resources/mosquitto.conf",
     ]
     "metadata" = {
       "labels" = {
         "env" = "test"
       }
       "name" = "mosquitto-config-file"
     }
   }
   "deployment" = {
     "metadata" = {
       "labels" = {
         "app" = "mosquitto"
       }
       "name" = "mosquitto"
     }
     "spec" = {
       "replicas" = 1
       "selector" = {
         "match_labels" = {
           "app" = "mosquitto"
         }
       }
       "template" = {
         "metadata" = {
           "labels" = {
             "app" = "mosquitto"
           }
         }
         "spec" = {
           "container" = [
             {
               "image" = "eclipse-mosquitto:1.6.2"
               "name" = "mosquitto"
               "port" = [
                 {
                   "container_port" = 1883
                 },
               ]
               "resources" = {
                 "limits" = {
                   "cpu" = "0.5"
                   "memory" = "512Mi"
                 }
                 "requests" = {
                   "cpu" = "250m"
                   "memory" = "50Mi"
                 }
               }
               "volume_mount" = [
                 {
                   "mount_path" = "/mosquitto/secret"
                   "name" = "mosquitto-secret-file"
                 },
                 {
                   "mount_path" = "mosquitto/config"
                   "name" = "mosquitto-config-file"
                 },
               ]
             },
             {
               "image" = "tomcat:8.5-jdk8-adoptopenjdk-openj9"
               "name" = "tomcat-example"
               "port" = [
                 {
                   "container_port" = 8080
                 },
               ]
               "resources" = {
                 "limits" = {
                   "cpu" = "0.5"
                   "memory" = "512Mi"
                 }
                 "requests" = {
                   "cpu" = "250m"
                   "memory" = "50Mi"
                 }
               }
             },
           ]
           "volume" = [
             {
               "config_map" = {
                 "name" = "mosquitto-config-file"
               }
               "name" = "mosquitto-config-file"
             },
             {
               "name" = "mosquitto-secret-file"
               "secret" = {
                 "secret_name" = "mosquitto-secret-file"
               }
             },
           ]
         }
       }
     }
   }
   "secret" = {
     "data" = {
       "login" = "login"
       "password" = "password"
     }
     "data_file" = [
       "../app_2/resources/secret.file",
     ]
     "metadata" = {
       "annotations" = {}
       "labels" = {
         "env" = "test"
       }
       "name" = "mosquitto-secret-file"
     }
     "type" = "Opaque"
   }
   "service" = {
     "metadata" = {
       "labels" = {
         "env" = "test"
       }
       "name" = "mosquitto"
     }
     "spec" = {
       "port" = [
         {
           "name" = "mosquitto-listener"
           "port" = 1883
           "target_port" = 1883
         },
         {
           "name" = "tomcat-listener"
           "port" = 80
           "target_port" = 8080
         },
       ]
       "selector" = {
         "app" = "mosquitto"
       }
       "type" = "LoadBalancer"
     }
   }
 }
 "app_2" = {
   "k8s_pod_autoscaler" = {
     "metadata" = {
       "name" = "test"
     }
     "spec" = {
       "max_replicas" = 100
       "metric" = {
         "external" = {
           "metric" = {
             "name" = "latency"
             "selector" = {
               "match_labels" = {
                 "lb_name" = "test"
               }
             }
           }
           "target" = {
             "type" = "Value"
             "value" = 100
           }
         }
         "type" = "External"
       }
       "min_replicas" = 50
       "scale_target_ref" = {
         "kind" = "Deployment"
         "name" = "MyApp"
       }
     }
   }
   "pod" = {
     "metadata" = {
       "labels" = {
         "app" = "TestApp"
       }
       "name" = "nginx-example"
     }
     "spec" = {
       "container" = [
         {
           "image" = "nginx:1.7.8"
           "liveness_probe" = {
             "http_get" = {
               "http_header" = {
                 "name" = "X-Custom-Header"
                 "value" = "Awesome"
               }
               "path" = "/"
               "port" = 80
             }
             "initial_delay_seconds" = 3
             "period_seconds" = 3
           }
           "name" = "nginx-example"
           "port" = [
             {
               "container_port" = 8080
             },
           ]
         },
       ]
       "dns_config" = {
         "nameservers" = [
           "1.1.1.1",
           "8.8.8.8",
           "9.9.9.9",
         ]
         "option" = [
           {
             "name" = "ndots"
             "value" = 1
           },
           {
             "name" = "use-vc"
           },
         ]
         "searches" = [
           "example.com",
         ]
       }
       "dns_policy" = "None"
       "env" = {
         "name" = "environment"
         "value" = "test"
       }
       "secret" = "pod-app-service-account-token-brds5"
       "service_account_name" = "pod-app-service-account"
     }
   }
   "service_account" = {
     "automount_service_account_token" = true
     "metadata" = {
       "name" = "pod-app-service-account"
     }
     "secret" = [
       {
         "name" = "pod-app-secret-file"
       },
     ]
   }
 }
 "default" = {
   "build_dir" = "build"
   "manual_scaling" = {
     "instances" = 1
   }
   "root_dir" = "mcp"
   "runtime" = "java8"
 }
}
k8s_config_map = {
 "app_1" = {
   "config_map" = {
     "binary_data" = {
       "bar" = "L3Jvb3QvMTAw"
     }
     "binary_file" = [
       "../app_2/resources/binary.bin",
     ]
     "data" = {
       "test" = "test"
     }
     "data_file" = [
       "../app_2/resources/mosquitto.conf",
     ]
     "metadata" = {
       "labels" = {
         "env" = "test"
       }
       "name" = "mosquitto-config-file"
     }
   }
 }
}
k8s_file = ../k8s.yml
kubernetes = {
 "components" = {
   "common" = {
     "name" = "name"
   }
   "specs" = {
     "app_1" = {
       "config_map" = {
         "binary_data" = {
           "bar" = "L3Jvb3QvMTAw"
         }
         "binary_file" = [
           "../app_2/resources/binary.bin",
         ]
         "data" = {
           "test" = "test"
         }
         "data_file" = [
           "../app_2/resources/mosquitto.conf",
         ]
         "metadata" = {
           "labels" = {
             "env" = "test"
           }
           "name" = "mosquitto-config-file"
         }
       }
       "deployment" = {
         "metadata" = {
           "labels" = {
             "app" = "mosquitto"
           }
           "name" = "mosquitto"
         }
         "spec" = {
           "replicas" = 1
           "selector" = {
             "match_labels" = {
               "app" = "mosquitto"
             }
           }
           "template" = {
             "metadata" = {
               "labels" = {
                 "app" = "mosquitto"
               }
             }
             "spec" = {
               "container" = [
                 {
                   "image" = "eclipse-mosquitto:1.6.2"
                   "name" = "mosquitto"
                   "port" = [
                     {
                       "container_port" = 1883
                     },
                   ]
                   "resources" = {
                     "limits" = {
                       "cpu" = "0.5"
                       "memory" = "512Mi"
                     }
                     "requests" = {
                       "cpu" = "250m"
                       "memory" = "50Mi"
                     }
                   }
                   "volume_mount" = [
                     {
                       "mount_path" = "/mosquitto/secret"
                       "name" = "mosquitto-secret-file"
                     },
                     {
                       "mount_path" = "mosquitto/config"
                       "name" = "mosquitto-config-file"
                     },
                   ]
                 },
                 {
                   "image" = "tomcat:8.5-jdk8-adoptopenjdk-openj9"
                   "name" = "tomcat-example"
                   "port" = [
                     {
                       "container_port" = 8080
                     },
                   ]
                   "resources" = {
                     "limits" = {
                       "cpu" = "0.5"
                       "memory" = "512Mi"
                     }
                     "requests" = {
                       "cpu" = "250m"
                       "memory" = "50Mi"
                     }
                   }
                 },
               ]
               "volume" = [
                 {
                   "config_map" = {
                     "name" = "mosquitto-config-file"
                   }
                   "name" = "mosquitto-config-file"
                 },
                 {
                   "name" = "mosquitto-secret-file"
                   "secret" = {
                     "secret_name" = "mosquitto-secret-file"
                   }
                 },
               ]
             }
           }
         }
       }
       "secret" = {
         "data" = {
           "login" = "login"
           "password" = "password"
         }
         "data_file" = [
           "../app_2/resources/secret.file",
         ]
         "metadata" = {
           "annotations" = {}
           "labels" = {
             "env" = "test"
           }
           "name" = "mosquitto-secret-file"
         }
         "type" = "Opaque"
       }
       "service" = {
         "metadata" = {
           "labels" = {
             "env" = "test"
           }
           "name" = "mosquitto"
         }
         "spec" = {
           "port" = [
             {
               "name" = "mosquitto-listener"
               "port" = 1883
               "target_port" = 1883
             },
             {
               "name" = "tomcat-listener"
               "port" = 80
               "target_port" = 8080
             },
           ]
           "selector" = {
             "app" = "mosquitto"
           }
           "type" = "LoadBalancer"
         }
       }
     }
     "app_2" = {
       "k8s_pod_autoscaler" = {
         "metadata" = {
           "name" = "test"
         }
         "spec" = {
           "max_replicas" = 100
           "metric" = {
             "external" = {
               "metric" = {
                 "name" = "latency"
                 "selector" = {
                   "match_labels" = {
                     "lb_name" = "test"
                   }
                 }
               }
               "target" = {
                 "type" = "Value"
                 "value" = 100
               }
             }
             "type" = "External"
           }
           "min_replicas" = 50
           "scale_target_ref" = {
             "kind" = "Deployment"
             "name" = "MyApp"
           }
         }
       }
       "pod" = {
         "metadata" = {
           "labels" = {
             "app" = "TestApp"
           }
           "name" = "nginx-example"
         }
         "spec" = {
           "container" = [
             {
               "image" = "nginx:1.7.8"
               "liveness_probe" = {
                 "http_get" = {
                   "http_header" = {
                     "name" = "X-Custom-Header"
                     "value" = "Awesome"
                   }
                   "path" = "/"
                   "port" = 80
                 }
                 "initial_delay_seconds" = 3
                 "period_seconds" = 3
               }
               "name" = "nginx-example"
               "port" = [
                 {
                   "container_port" = 8080
                 },
               ]
             },
           ]
           "dns_config" = {
             "nameservers" = [
               "1.1.1.1",
               "8.8.8.8",
               "9.9.9.9",
             ]
             "option" = [
               {
                 "name" = "ndots"
                 "value" = 1
               },
               {
                 "name" = "use-vc"
               },
             ]
             "searches" = [
               "example.com",
             ]
           }
           "dns_policy" = "None"
           "env" = {
             "name" = "environment"
             "value" = "test"
           }
           "secret" = "pod-app-service-account-token-brds5"
           "service_account_name" = "pod-app-service-account"
         }
       }
       "service_account" = {
         "automount_service_account_token" = true
         "metadata" = {
           "name" = "pod-app-service-account"
         }
         "secret" = [
           {
             "name" = "pod-app-secret-file"
           },
         ]
       }
     }
     "default" = {
       "build_dir" = "build"
       "manual_scaling" = {
         "instances" = 1
       }
       "root_dir" = "mcp"
       "runtime" = "java8"
     }
   }
 }
}
dmitrogavrichuk@iMac-Dmitro  ~/DEVOPS/Mesoform/global_structure_test/terraform 
dmitrogavrichuk@iMac-Dmitro  ~/DEVOPS/Mesoform/global_structure_test/terraform  terraform destroy
module.mcp.data.google_project.default[0]: Refreshing state... [id=projects/global-cluster-2]
module.mcp.data.google_project.self[0]: Refreshing state... [id=projects/global-cluster-2]
module.mcp.data.google_iam_policy.noauth["default"]: Refreshing state... [id=3450855414]
module.mcp.data.google_iam_policy.auth["default"]: Refreshing state... [id=2745614147]
module.mcp.kubernetes_service.self["app_1"]: Refreshing state... [id=default/mosquitto]
module.mcp.kubernetes_service_account.self["app_2"]: Refreshing state... [id=default/pod-app-service-account]
module.mcp.kubernetes_config_map.self["app_1"]: Refreshing state... [id=default/mosquitto-config-file]
module.mcp.kubernetes_secret.self["app_1"]: Refreshing state... [id=default/mosquitto-secret-file]
module.mcp.kubernetes_pod.self["app_2"]: Refreshing state... [id=default/nginx-example]
module.mcp.kubernetes_deployment.self["app_1"]: Refreshing state... [id=default/mosquitto]
module.mcp.google_project_service.iam[0]: Refreshing state... [id=global-cluster-2/iam.googleapis.com]
module.mcp.google_project_service.cloudrun[0]: Refreshing state... [id=global-cluster-2/run.googleapis.com]
module.mcp.google_project_service.std[0]: Refreshing state... [id=global-cluster-2/appengine.googleapis.com]
module.mcp.google_storage_bucket.self[0]: Refreshing state... [id=global-cluster-2]
module.mcp.google_storage_bucket_object.self["../app_1/build/helloworld/requirements.txt"]: Refreshing state... [id=global-cluster-2-570b1896080f7368d7a8737d020cfe252416d2c9]
module.mcp.google_storage_bucket_object.self["../app_1/build/helloworld/main.py"]: Refreshing state... [id=global-cluster-2-6bcd5ab8b7d46f59780ba2497c112294220aa0cb]
module.mcp.google_app_engine_application.self[0]: Refreshing state... [id=global-cluster-2]
module.mcp.google_app_engine_standard_app_version.self["default"]: Refreshing state... [id=apps/global-cluster-2/services/default/versions/1]
module.mcp.google_cloud_run_service.self["default"]: Refreshing state... [id=locations/europe-west2/namespaces/global-cluster-2/services/default]
module.mcp.google_cloud_run_service_iam_policy.self["default"]: Refreshing state... [id=v1/projects/global-cluster-2/locations/europe-west2/services/default]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
 - destroy

Terraform will perform the following actions:

 # module.mcp.google_app_engine_application.self[0] will be destroyed
 - resource "google_app_engine_application" "self" {
     - app_id            = "global-cluster-2" -> null
     - auth_domain       = "gmail.com" -> null
     - code_bucket       = "staging.global-cluster-2.appspot.com" -> null
     - database_type     = "CLOUD_DATASTORE_COMPATIBILITY" -> null
     - default_bucket    = "global-cluster-2.appspot.com" -> null
     - default_hostname  = "global-cluster-2.nw.r.appspot.com" -> null
     - gcr_domain        = "eu.gcr.io" -> null
     - id                = "global-cluster-2" -> null
     - location_id       = "europe-west2" -> null
     - name              = "apps/global-cluster-2" -> null
     - project           = "global-cluster-2" -> null
     - serving_status    = "SERVING" -> null
     - url_dispatch_rule = [] -> null

     - feature_settings {
         - split_health_checks = true -> null
       }
   }

 # module.mcp.google_app_engine_standard_app_version.self["default"] will be destroyed
 - resource "google_app_engine_standard_app_version" "self" {
     - delete_service_on_destroy = false -> null
     - env_variables             = {
         - "GCP_PROJECT_ID" = "global-cluster-2"
       } -> null
     - id                        = "apps/global-cluster-2/services/default/versions/1" -> null
     - inbound_services          = [] -> null
     - instance_class            = "F1" -> null
     - name                      = "apps/global-cluster-2/services/default/versions/1" -> null
     - noop_on_destroy           = false -> null
     - project                   = "global-cluster-2" -> null
     - runtime                   = "python37" -> null
     - service                   = "default" -> null
     - version_id                = "1" -> null

     - deployment {
         - files {
             - name       = "main.py" -> null
             - sha1_sum   = "6bcd5ab8b7d46f59780ba2497c112294220aa0cb" -> null
             - source_url = "https://storage.googleapis.com/global-cluster-2/6bcd5ab8b7d46f59780ba2497c112294220aa0cb" -> null
           }
         - files {
             - name       = "requirements.txt" -> null
             - sha1_sum   = "570b1896080f7368d7a8737d020cfe252416d2c9" -> null
             - source_url = "https://storage.googleapis.com/global-cluster-2/570b1896080f7368d7a8737d020cfe252416d2c9" -> null
           }
       }

     - entrypoint {
         - shell = "python main.py" -> null
       }

     - handlers {
         - auth_fail_action = "AUTH_FAIL_ACTION_REDIRECT" -> null
         - login            = "LOGIN_OPTIONAL" -> null
         - security_level   = "SECURE_OPTIONAL" -> null
         - url_regex        = ".*" -> null

         - script {
             - script_path = "auto" -> null
           }
       }
   }

 # module.mcp.google_cloud_run_service.self["default"] will be destroyed
 - resource "google_cloud_run_service" "self" {
     - autogenerate_revision_name = false -> null
     - id                         = "locations/europe-west2/namespaces/global-cluster-2/services/default" -> null
     - location                   = "europe-west2" -> null
     - name                       = "default" -> null
     - project                    = "global-cluster-2" -> null
     - status                     = [
         - {
             - conditions                   = [
                 - {
                     - message = ""
                     - reason  = ""
                     - status  = "True"
                     - type    = "Ready"
                   },
                 - {
                     - message = ""
                     - reason  = ""
                     - status  = "True"
                     - type    = "ConfigurationsReady"
                   },
                 - {
                     - message = ""
                     - reason  = ""
                     - status  = "True"
                     - type    = "RoutesReady"
                   },
               ]
             - latest_created_revision_name = "default-tw546"
             - latest_ready_revision_name   = "default-tw546"
             - observed_generation          = 1
             - url                          = "https://default-oeywk2tdhq-nw.a.run.app"
           },
       ] -> null

     - metadata {
         - annotations      = {
             - "serving.knative.dev/creator"      = "sautlan@gmail.com"
             - "serving.knative.dev/lastModifier" = "sautlan@gmail.com"
           } -> null
         - generation       = 1 -> null
         - labels           = {
             - "cloud.googleapis.com/location" = "europe-west2"
           } -> null
         - namespace        = "global-cluster-2" -> null
         - resource_version = "AAW1fOH2tCw" -> null
         - self_link        = "/apis/serving.knative.dev/v1/namespaces/115011585027/services/default" -> null
         - uid              = "3740ef52-d031-4419-a655-f3ef1272d54b" -> null
       }

     - template {
         - metadata {
             - annotations = {
                 - "autoscaling.knative.dev/maxScale" = "1000"
                 - "run.googleapis.com/client-name"   = "terraform"
               } -> null
             - generation  = 0 -> null
             - labels      = {} -> null
           }

         - spec {
             - container_concurrency = 80 -> null
             - timeout_seconds       = 300 -> null

             - containers {
                 - args    = [] -> null
                 - command = [] -> null
                 - image   = "gcr.io/global-cluster-2/helloworld" -> null

                 - ports {
                     - container_port = 8080 -> null
                   }

                 - resources {
                     - limits   = {
                         - "cpu"    = "1000m"
                         - "memory" = "256Mi"
                       } -> null
                     - requests = {} -> null
                   }
               }
           }
       }

     - traffic {
         - latest_revision = true -> null
         - percent         = 100 -> null
       }
   }

 # module.mcp.google_cloud_run_service_iam_policy.self["default"] will be destroyed
 - resource "google_cloud_run_service_iam_policy" "self" {
     - etag        = "BwW1fOIFgwk=" -> null
     - id          = "v1/projects/global-cluster-2/locations/europe-west2/services/default" -> null
     - location    = "europe-west2" -> null
     - policy_data = jsonencode(
           {
             - bindings = [
                 - {
                     - members = [
                         - "allUsers",
                       ]
                     - role    = "roles/run.invoker"
                   },
               ]
           }
       ) -> null
     - project     = "global-cluster-2" -> null
     - service     = "v1/projects/global-cluster-2/locations/europe-west2/services/default" -> null
   }

 # module.mcp.google_project_service.cloudrun[0] will be destroyed
 - resource "google_project_service" "cloudrun" {
     - disable_dependent_services = true -> null
     - disable_on_destroy         = true -> null
     - id                         = "global-cluster-2/run.googleapis.com" -> null
     - project                    = "global-cluster-2" -> null
     - service                    = "run.googleapis.com" -> null
   }

 # module.mcp.google_project_service.iam[0] will be destroyed
 - resource "google_project_service" "iam" {
     - disable_on_destroy = false -> null
     - id                 = "global-cluster-2/iam.googleapis.com" -> null
     - project            = "global-cluster-2" -> null
     - service            = "iam.googleapis.com" -> null
   }

 # module.mcp.google_project_service.std[0] will be destroyed
 - resource "google_project_service" "std" {
     - disable_dependent_services = true -> null
     - disable_on_destroy         = true -> null
     - id                         = "global-cluster-2/appengine.googleapis.com" -> null
     - project                    = "global-cluster-2" -> null
     - service                    = "appengine.googleapis.com" -> null
   }

 # module.mcp.google_storage_bucket.self[0] will be destroyed
 - resource "google_storage_bucket" "self" {
     - bucket_policy_only          = true -> null
     - default_event_based_hold    = false -> null
     - force_destroy               = true -> null
     - id                          = "global-cluster-2" -> null
     - labels                      = {
         - "billing" = "central"
       } -> null
     - location                    = "EUROPE-WEST2" -> null
     - name                        = "global-cluster-2" -> null
     - project                     = "global-cluster-2" -> null
     - requester_pays              = false -> null
     - self_link                   = "https://www.googleapis.com/storage/v1/b/global-cluster-2" -> null
     - storage_class               = "REGIONAL" -> null
     - uniform_bucket_level_access = true -> null
     - url                         = "gs://global-cluster-2" -> null

     - versioning {
         - enabled = true -> null
       }
   }

 # module.mcp.google_storage_bucket_object.self["../app_1/build/helloworld/main.py"] will be destroyed
 - resource "google_storage_bucket_object" "self" {
     - bucket         = "global-cluster-2" -> null
     - content_type   = "text/plain; charset=utf-8" -> null
     - crc32c         = "64YPnA==" -> null
     - detect_md5hash = "Wvc4V53funYs1r1Wn76Qaw==" -> null
     - id             = "global-cluster-2-6bcd5ab8b7d46f59780ba2497c112294220aa0cb" -> null
     - md5hash        = "Wvc4V53funYs1r1Wn76Qaw==" -> null
     - media_link     = "https://storage.googleapis.com/download/storage/v1/b/global-cluster-2/o/6bcd5ab8b7d46f59780ba2497c112294220aa0cb?generation=1606922720714471&alt=media" -> null
     - metadata       = {} -> null
     - name           = "6bcd5ab8b7d46f59780ba2497c112294220aa0cb" -> null
     - output_name    = "6bcd5ab8b7d46f59780ba2497c112294220aa0cb" -> null
     - self_link      = "https://www.googleapis.com/storage/v1/b/global-cluster-2/o/6bcd5ab8b7d46f59780ba2497c112294220aa0cb" -> null
     - source         = "../app_1/build/helloworld/main.py" -> null
     - storage_class  = "REGIONAL" -> null
   }

 # module.mcp.google_storage_bucket_object.self["../app_1/build/helloworld/requirements.txt"] will be destroyed
 - resource "google_storage_bucket_object" "self" {
     - bucket         = "global-cluster-2" -> null
     - content_type   = "text/plain; charset=utf-8" -> null
     - crc32c         = "vu3lCg==" -> null
     - detect_md5hash = "A1IVN4WEgBocl8QMktf0aA==" -> null
     - id             = "global-cluster-2-570b1896080f7368d7a8737d020cfe252416d2c9" -> null
     - md5hash        = "A1IVN4WEgBocl8QMktf0aA==" -> null
     - media_link     = "https://storage.googleapis.com/download/storage/v1/b/global-cluster-2/o/570b1896080f7368d7a8737d020cfe252416d2c9?generation=1606922721315497&alt=media" -> null
     - metadata       = {} -> null
     - name           = "570b1896080f7368d7a8737d020cfe252416d2c9" -> null
     - output_name    = "570b1896080f7368d7a8737d020cfe252416d2c9" -> null
     - self_link      = "https://www.googleapis.com/storage/v1/b/global-cluster-2/o/570b1896080f7368d7a8737d020cfe252416d2c9" -> null
     - source         = "../app_1/build/helloworld/requirements.txt" -> null
     - storage_class  = "REGIONAL" -> null
   }

 # module.mcp.kubernetes_config_map.self["app_1"] will be destroyed
 - resource "kubernetes_config_map" "self" {
     - binary_data = {
         - "bar"        = "L3Jvb3QvMTAw"
         - "binary.bin" = "SGVsbG8gV29ybGQ="
       } -> null
     - data        = {
         - "mosquitto.conf" = <<~EOT
               log_dest stdout
               log_type all
               log_timestamp true
               listener 9001
           EOT
         - "test"           = "test"
       } -> null
     - id          = "default/mosquitto-config-file" -> null

     - metadata {
         - annotations      = {} -> null
         - generation       = 0 -> null
         - labels           = {
             - "env" = "test"
           } -> null
         - name             = "mosquitto-config-file" -> null
         - namespace        = "default" -> null
         - resource_version = "10392" -> null
         - self_link        = "/api/v1/namespaces/default/configmaps/mosquitto-config-file" -> null
         - uid              = "011024b3-7e98-4d22-8d89-70e1bc2b6210" -> null
       }
   }

 # module.mcp.kubernetes_deployment.self["app_1"] will be destroyed
 - resource "kubernetes_deployment" "self" {
     - id               = "default/mosquitto" -> null
     - wait_for_rollout = true -> null

     - metadata {
         - annotations      = {} -> null
         - generation       = 1 -> null
         - labels           = {
             - "app" = "mosquitto"
           } -> null
         - name             = "mosquitto" -> null
         - namespace        = "default" -> null
         - resource_version = "10523" -> null
         - self_link        = "/apis/apps/v1/namespaces/default/deployments/mosquitto" -> null
         - uid              = "ccbb12d7-77e3-43b4-b859-a34835286dd8" -> null
       }

     - spec {
         - min_ready_seconds         = 0 -> null
         - paused                    = false -> null
         - progress_deadline_seconds = 600 -> null
         - replicas                  = 1 -> null
         - revision_history_limit    = 10 -> null

         - selector {
             - match_labels = {
                 - "app" = "mosquitto"
               } -> null
           }

         - strategy {
             - type = "RollingUpdate" -> null

             - rolling_update {
                 - max_surge       = "25%" -> null
                 - max_unavailable = "25%" -> null
               }
           }

         - template {
             - metadata {
                 - annotations = {} -> null
                 - generation  = 0 -> null
                 - labels      = {
                     - "app" = "mosquitto"
                   } -> null
               }

             - spec {
                 - active_deadline_seconds          = 0 -> null
                 - automount_service_account_token  = false -> null
                 - dns_policy                       = "ClusterFirst" -> null
                 - enable_service_links             = true -> null
                 - host_ipc                         = false -> null
                 - host_network                     = false -> null
                 - host_pid                         = false -> null
                 - node_selector                    = {} -> null
                 - restart_policy                   = "Always" -> null
                 - share_process_namespace          = false -> null
                 - termination_grace_period_seconds = 30 -> null

                 - container {
                     - args                       = [] -> null
                     - command                    = [] -> null
                     - image                      = "eclipse-mosquitto:1.6.2" -> null
                     - image_pull_policy          = "IfNotPresent" -> null
                     - name                       = "mosquitto" -> null
                     - stdin                      = false -> null
                     - stdin_once                 = false -> null
                     - termination_message_path   = "/dev/termination-log" -> null
                     - termination_message_policy = "File" -> null
                     - tty                        = false -> null

                     - port {
                         - container_port = 1883 -> null
                         - host_port      = 0 -> null
                         - protocol       = "TCP" -> null
                       }

                     - resources {
                         - limits {
                             - cpu    = "500m" -> null
                             - memory = "512Mi" -> null
                           }

                         - requests {
                             - cpu    = "250m" -> null
                             - memory = "50Mi" -> null
                           }
                       }

                     - volume_mount {
                         - mount_path        = "/mosquitto/secret" -> null
                         - mount_propagation = "None" -> null
                         - name              = "mosquitto-secret-file" -> null
                         - read_only         = false -> null
                       }
                     - volume_mount {
                         - mount_path        = "mosquitto/config" -> null
                         - mount_propagation = "None" -> null
                         - name              = "mosquitto-config-file" -> null
                         - read_only         = false -> null
                       }
                   }
                 - container {
                     - args                       = [] -> null
                     - command                    = [] -> null
                     - image                      = "tomcat:8.5-jdk8-adoptopenjdk-openj9" -> null
                     - image_pull_policy          = "IfNotPresent" -> null
                     - name                       = "tomcat-example" -> null
                     - stdin                      = false -> null
                     - stdin_once                 = false -> null
                     - termination_message_path   = "/dev/termination-log" -> null
                     - termination_message_policy = "File" -> null
                     - tty                        = false -> null

                     - port {
                         - container_port = 8080 -> null
                         - host_port      = 0 -> null
                         - protocol       = "TCP" -> null
                       }

                     - resources {
                         - limits {
                             - cpu    = "500m" -> null
                             - memory = "512Mi" -> null
                           }

                         - requests {
                             - cpu    = "250m" -> null
                             - memory = "50Mi" -> null
                           }
                       }
                   }

                 - volume {
                     - name = "mosquitto-config-file" -> null

                     - config_map {
                         - default_mode = "0644" -> null
                         - name         = "mosquitto-config-file" -> null
                         - optional     = false -> null
                       }
                   }
                 - volume {
                     - name = "mosquitto-secret-file" -> null

                     - secret {
                         - default_mode = "0644" -> null
                         - optional     = false -> null
                         - secret_name  = "mosquitto-secret-file" -> null
                       }
                   }
               }
           }
       }
   }

 # module.mcp.kubernetes_pod.self["app_2"] will be destroyed
 - resource "kubernetes_pod" "self" {
     - id = "default/nginx-example" -> null

     - metadata {
         - annotations      = {} -> null
         - generation       = 0 -> null
         - labels           = {
             - "app" = "TestApp"
           } -> null
         - name             = "nginx-example" -> null
         - namespace        = "default" -> null
         - resource_version = "10453" -> null
         - self_link        = "/api/v1/namespaces/default/pods/nginx-example" -> null
         - uid              = "c718dc32-2e6e-47cf-8421-155201f03296" -> null
       }

     - spec {
         - active_deadline_seconds          = 0 -> null
         - automount_service_account_token  = false -> null
         - dns_policy                       = "None" -> null
         - enable_service_links             = true -> null
         - host_ipc                         = false -> null
         - host_network                     = false -> null
         - host_pid                         = false -> null
         - node_name                        = "gke-global-cluster-2-global-cluster-2-de93144a-fzgv" -> null
         - node_selector                    = {} -> null
         - restart_policy                   = "Always" -> null
         - service_account_name             = "pod-app-service-account" -> null
         - share_process_namespace          = false -> null
         - termination_grace_period_seconds = 30 -> null

         - container {
             - args                       = [] -> null
             - command                    = [] -> null
             - image                      = "nginx:1.7.8" -> null
             - image_pull_policy          = "IfNotPresent" -> null
             - name                       = "nginx-example" -> null
             - stdin                      = false -> null
             - stdin_once                 = false -> null
             - termination_message_path   = "/dev/termination-log" -> null
             - termination_message_policy = "File" -> null
             - tty                        = false -> null

             - liveness_probe {
                 - failure_threshold     = 3 -> null
                 - initial_delay_seconds = 3 -> null
                 - period_seconds        = 3 -> null
                 - success_threshold     = 1 -> null
                 - timeout_seconds       = 1 -> null

                 - http_get {
                     - path   = "/" -> null
                     - port   = "80" -> null
                     - scheme = "HTTP" -> null

                     - http_header {
                         - name  = "X-Custom-Header" -> null
                         - value = "Awesome" -> null
                       }
                   }
               }

             - port {
                 - container_port = 8080 -> null
                 - host_port      = 0 -> null
                 - protocol       = "TCP" -> null
               }

             - resources {

                 - requests {
                     - cpu = "100m" -> null
                   }
               }
           }

         - dns_config {
             - nameservers = [
                 - "1.1.1.1",
                 - "8.8.8.8",
                 - "9.9.9.9",
               ] -> null
             - searches    = [
                 - "example.com",
               ] -> null

             - option {
                 - name  = "ndots" -> null
                 - value = "1" -> null
               }
             - option {
                 - name = "use-vc" -> null
               }
           }
       }
   }

 # module.mcp.kubernetes_secret.self["app_1"] will be destroyed
 - resource "kubernetes_secret" "self" {
     - data = (sensitive value)
     - id   = "default/mosquitto-secret-file" -> null
     - type = "Opaque" -> null

     - metadata {
         - annotations      = {} -> null
         - generation       = 0 -> null
         - labels           = {
             - "env" = "test"
           } -> null
         - name             = "mosquitto-secret-file" -> null
         - namespace        = "default" -> null
         - resource_version = "10386" -> null
         - self_link        = "/api/v1/namespaces/default/secrets/mosquitto-secret-file" -> null
         - uid              = "fbe12e02-6959-4d80-9538-4b22a4665273" -> null
       }
   }

 # module.mcp.kubernetes_service.self["app_1"] will be destroyed
 - resource "kubernetes_service" "self" {
     - id                    = "default/mosquitto" -> null
     - load_balancer_ingress = [
         - {
             - hostname = ""
             - ip       = "35.242.157.235"
           },
       ] -> null

     - metadata {
         - annotations      = {} -> null
         - generation       = 0 -> null
         - labels           = {
             - "env" = "test"
           } -> null
         - name             = "mosquitto" -> null
         - namespace        = "default" -> null
         - resource_version = "10629" -> null
         - self_link        = "/api/v1/namespaces/default/services/mosquitto" -> null
         - uid              = "0cf86eba-7a8b-4f5d-ace7-1eb08d4c2e14" -> null
       }

     - spec {
         - cluster_ip                  = "10.71.255.49" -> null
         - external_ips                = [] -> null
         - external_traffic_policy     = "Cluster" -> null
         - health_check_node_port      = 0 -> null
         - load_balancer_source_ranges = [] -> null
         - publish_not_ready_addresses = false -> null
         - selector                    = {
             - "app" = "mosquitto"
           } -> null
         - session_affinity            = "None" -> null
         - type                        = "LoadBalancer" -> null

         - port {
             - name        = "mosquitto-listener" -> null
             - node_port   = 30059 -> null
             - port        = 1883 -> null
             - protocol    = "TCP" -> null
             - target_port = "1883" -> null
           }
         - port {
             - name        = "tomcat-listener" -> null
             - node_port   = 30931 -> null
             - port        = 80 -> null
             - protocol    = "TCP" -> null
             - target_port = "8080" -> null
           }
       }
   }

 # module.mcp.kubernetes_service_account.self["app_2"] will be destroyed
 - resource "kubernetes_service_account" "self" {
     - automount_service_account_token = false -> null
     - default_secret_name             = "pod-app-service-account-token-97shw" -> null
     - id                              = "default/pod-app-service-account" -> null

     - metadata {
         - annotations      = {} -> null
         - generation       = 0 -> null
         - labels           = {} -> null
         - name             = "pod-app-service-account" -> null
         - namespace        = "default" -> null
         - resource_version = "10403" -> null
         - self_link        = "/api/v1/namespaces/default/serviceaccounts/pod-app-service-account" -> null
         - uid              = "ba57d88a-531d-4aca-9ab9-9b1975c6f0fa" -> null
       }

     - secret {
         - name = "pod-app-secret-file" -> null
       }
   }

Plan: 0 to add, 0 to change, 16 to destroy.

Changes to Outputs:
 - k8s_components       = {
     - common = {
         - name = "name"
       }
     - specs  = {
         - app_1   = {
             - config_map = {
                 - binary_data = {
                     - bar = "L3Jvb3QvMTAw"
                   }
                 - binary_file = [
                     - "../app_2/resources/binary.bin",
                   ]
                 - data        = {
                     - test = "test"
                   }
                 - data_file   = [
                     - "../app_2/resources/mosquitto.conf",
                   ]
                 - metadata    = {
                     - labels = {
                         - env = "test"
                       }
                     - name   = "mosquitto-config-file"
                   }
               }
             - deployment = {
                 - metadata = {
                     - labels    = {
                         - app = "mosquitto"
                       }
                     - name      = "mosquitto"
                     - namespace = null
                   }
                 - spec     = {
                     - replicas = 1
                     - selector = {
                         - match_labels = {
                             - app = "mosquitto"
                           }
                       }
                     - template = {
                         - metadata = {
                             - labels = {
                                 - app = "mosquitto"
                               }
                           }
                         - spec     = {
                             - container = [
                                 - {
                                     - image        = "eclipse-mosquitto:1.6.2"
                                     - name         = "mosquitto"
                                     - port         = [
                                         - {
                                             - container_port = 1883
                                           },
                                       ]
                                     - resources    = {
                                         - limits   = {
                                             - cpu    = "0.5"
                                             - memory = "512Mi"
                                           }
                                         - requests = {
                                             - cpu    = "250m"
                                             - memory = "50Mi"
                                           }
                                       }
                                     - volume_mount = [
                                         - {
                                             - mount_path = "/mosquitto/secret"
                                             - name       = "mosquitto-secret-file"
                                           },
                                         - {
                                             - mount_path = "mosquitto/config"
                                             - name       = "mosquitto-config-file"
                                           },
                                       ]
                                   },
                                 - {
                                     - image     = "tomcat:8.5-jdk8-adoptopenjdk-openj9"
                                     - name      = "tomcat-example"
                                     - port      = [
                                         - {
                                             - container_port = 8080
                                           },
                                       ]
                                     - resources = {
                                         - limits   = {
                                             - cpu    = "0.5"
                                             - memory = "512Mi"
                                           }
                                         - requests = {
                                             - cpu    = "250m"
                                             - memory = "50Mi"
                                           }
                                       }
                                   },
                               ]
                             - volume    = [
                                 - {
                                     - config_map = {
                                         - name = "mosquitto-config-file"
                                       }
                                     - name       = "mosquitto-config-file"
                                   },
                                 - {
                                     - name   = "mosquitto-secret-file"
                                     - secret = {
                                         - secret_name = "mosquitto-secret-file"
                                       }
                                   },
                               ]
                           }
                       }
                   }
               }
             - secret     = {
                 - data      = {
                     - login    = "login"
                     - password = "password"
                   }
                 - data_file = [
                     - "../app_2/resources/secret.file",
                   ]
                 - metadata  = {
                     - annotations = {
                         - key1 = null
                         - key2 = null
                       }
                     - labels      = {
                         - env = "test"
                       }
                     - name        = "mosquitto-secret-file"
                     - namespace   = null
                   }
                 - type      = "Opaque"
               }
             - service    = {
                 - metadata = {
                     - generate_name = null
                     - labels        = {
                         - env = "test"
                       }
                     - name          = "mosquitto"
                     - namespace     = null
                   }
                 - spec     = {
                     - port     = [
                         - {
                             - name        = "mosquitto-listener"
                             - port        = 1883
                             - target_port = 1883
                           },
                         - {
                             - name        = "tomcat-listener"
                             - port        = 80
                             - target_port = 8080
                           },
                       ]
                     - selector = {
                         - app = "mosquitto"
                       }
                     - type     = "LoadBalancer"
                   }
               }
           }
         - app_2   = {
             - k8s_pod_autoscaler = {
                 - metadata = {
                     - name = "test"
                   }
                 - spec     = {
                     - max_replicas     = 100
                     - metric           = {
                         - external = {
                             - metric = {
                                 - name     = "latency"
                                 - selector = {
                                     - match_labels = {
                                         - lb_name = "test"
                                       }
                                   }
                               }
                             - target = {
                                 - type  = "Value"
                                 - value = 100
                               }
                           }
                         - type     = "External"
                       }
                     - min_replicas     = 50
                     - scale_target_ref = {
                         - kind = "Deployment"
                         - name = "MyApp"
                       }
                   }
               }
             - pod                = {
                 - metadata = {
                     - labels    = {
                         - app = "TestApp"
                       }
                     - name      = "nginx-example"
                     - namespace = null
                   }
                 - spec     = {
                     - container            = [
                         - {
                             - image          = "nginx:1.7.8"
                             - liveness_probe = {
                                 - http_get              = {
                                     - http_header = {
                                         - name  = "X-Custom-Header"
                                         - value = "Awesome"
                                       }
                                     - path        = "/"
                                     - port        = 80
                                   }
                                 - initial_delay_seconds = 3
                                 - period_seconds        = 3
                               }
                             - name           = "nginx-example"
                             - port           = [
                                 - {
                                     - container_port = 8080
                                   },
                               ]
                           },
                       ]
                     - dns_config           = {
                         - nameservers = [
                             - "1.1.1.1",
                             - "8.8.8.8",
                             - "9.9.9.9",
                           ]
                         - option      = [
                             - {
                                 - name  = "ndots"
                                 - value = 1
                               },
                             - {
                                 - name = "use-vc"
                               },
                           ]
                         - searches    = [
                             - "example.com",
                           ]
                       }
                     - dns_policy           = "None"
                     - env                  = {
                         - name  = "environment"
                         - value = "test"
                       }
                     - secret               = "pod-app-service-account-token-brds5"
                     - service_account_name = "pod-app-service-account"
                   }
               }
             - service_account    = {
                 - automount_service_account_token = true
                 - metadata                        = {
                     - name = "pod-app-service-account"
                   }
                 - secret                          = [
                     - {
                         - name = "pod-app-secret-file"
                       },
                   ]
               }
           }
         - default = {
             - build_dir      = "build"
             - manual_scaling = {
                 - instances = 1
               }
             - root_dir       = "mcp"
             - runtime        = "java8"
           }
       }
   } -> null
 - k8s_components_specs = {
     - app_1   = {
         - config_map = {
             - binary_data = {
                 - bar = "L3Jvb3QvMTAw"
               }
             - binary_file = [
                 - "../app_2/resources/binary.bin",
               ]
             - data        = {
                 - test = "test"
               }
             - data_file   = [
                 - "../app_2/resources/mosquitto.conf",
               ]
             - metadata    = {
                 - labels = {
                     - env = "test"
                   }
                 - name   = "mosquitto-config-file"
               }
           }
         - deployment = {
             - metadata = {
                 - labels    = {
                     - app = "mosquitto"
                   }
                 - name      = "mosquitto"
                 - namespace = null
               }
             - spec     = {
                 - replicas = 1
                 - selector = {
                     - match_labels = {
                         - app = "mosquitto"
                       }
                   }
                 - template = {
                     - metadata = {
                         - labels = {
                             - app = "mosquitto"
                           }
                       }
                     - spec     = {
                         - container = [
                             - {
                                 - image        = "eclipse-mosquitto:1.6.2"
                                 - name         = "mosquitto"
                                 - port         = [
                                     - {
                                         - container_port = 1883
                                       },
                                   ]
                                 - resources    = {
                                     - limits   = {
                                         - cpu    = "0.5"
                                         - memory = "512Mi"
                                       }
                                     - requests = {
                                         - cpu    = "250m"
                                         - memory = "50Mi"
                                       }
                                   }
                                 - volume_mount = [
                                     - {
                                         - mount_path = "/mosquitto/secret"
                                         - name       = "mosquitto-secret-file"
                                       },
                                     - {
                                         - mount_path = "mosquitto/config"
                                         - name       = "mosquitto-config-file"
                                       },
                                   ]
                               },
                             - {
                                 - image     = "tomcat:8.5-jdk8-adoptopenjdk-openj9"
                                 - name      = "tomcat-example"
                                 - port      = [
                                     - {
                                         - container_port = 8080
                                       },
                                   ]
                                 - resources = {
                                     - limits   = {
                                         - cpu    = "0.5"
                                         - memory = "512Mi"
                                       }
                                     - requests = {
                                         - cpu    = "250m"
                                         - memory = "50Mi"
                                       }
                                   }
                               },
                           ]
                         - volume    = [
                             - {
                                 - config_map = {
                                     - name = "mosquitto-config-file"
                                   }
                                 - name       = "mosquitto-config-file"
                               },
                             - {
                                 - name   = "mosquitto-secret-file"
                                 - secret = {
                                     - secret_name = "mosquitto-secret-file"
                                   }
                               },
                           ]
                       }
                   }
               }
           }
         - secret     = {
             - data      = {
                 - login    = "login"
                 - password = "password"
               }
             - data_file = [
                 - "../app_2/resources/secret.file",
               ]
             - metadata  = {
                 - annotations = {
                     - key1 = null
                     - key2 = null
                   }
                 - labels      = {
                     - env = "test"
                   }
                 - name        = "mosquitto-secret-file"
                 - namespace   = null
               }
             - type      = "Opaque"
           }
         - service    = {
             - metadata = {
                 - generate_name = null
                 - labels        = {
                     - env = "test"
                   }
                 - name          = "mosquitto"
                 - namespace     = null
               }
             - spec     = {
                 - port     = [
                     - {
                         - name        = "mosquitto-listener"
                         - port        = 1883
                         - target_port = 1883
                       },
                     - {
                         - name        = "tomcat-listener"
                         - port        = 80
                         - target_port = 8080
                       },
                   ]
                 - selector = {
                     - app = "mosquitto"
                   }
                 - type     = "LoadBalancer"
               }
           }
       }
     - app_2   = {
         - k8s_pod_autoscaler = {
             - metadata = {
                 - name = "test"
               }
             - spec     = {
                 - max_replicas     = 100
                 - metric           = {
                     - external = {
                         - metric = {
                             - name     = "latency"
                             - selector = {
                                 - match_labels = {
                                     - lb_name = "test"
                                   }
                               }
                           }
                         - target = {
                             - type  = "Value"
                             - value = 100
                           }
                       }
                     - type     = "External"
                   }
                 - min_replicas     = 50
                 - scale_target_ref = {
                     - kind = "Deployment"
                     - name = "MyApp"
                   }
               }
           }
         - pod                = {
             - metadata = {
                 - labels    = {
                     - app = "TestApp"
                   }
                 - name      = "nginx-example"
                 - namespace = null
               }
             - spec     = {
                 - container            = [
                     - {
                         - image          = "nginx:1.7.8"
                         - liveness_probe = {
                             - http_get              = {
                                 - http_header = {
                                     - name  = "X-Custom-Header"
                                     - value = "Awesome"
                                   }
                                 - path        = "/"
                                 - port        = 80
                               }
                             - initial_delay_seconds = 3
                             - period_seconds        = 3
                           }
                         - name           = "nginx-example"
                         - port           = [
                             - {
                                 - container_port = 8080
                               },
                           ]
                       },
                   ]
                 - dns_config           = {
                     - nameservers = [
                         - "1.1.1.1",
                         - "8.8.8.8",
                         - "9.9.9.9",
                       ]
                     - option      = [
                         - {
                             - name  = "ndots"
                             - value = 1
                           },
                         - {
                             - name = "use-vc"
                           },
                       ]
                     - searches    = [
                         - "example.com",
                       ]
                   }
                 - dns_policy           = "None"
                 - env                  = {
                     - name  = "environment"
                     - value = "test"
                   }
                 - secret               = "pod-app-service-account-token-brds5"
                 - service_account_name = "pod-app-service-account"
               }
           }
         - service_account    = {
             - automount_service_account_token = true
             - metadata                        = {
                 - name = "pod-app-service-account"
               }
             - secret                          = [
                 - {
                     - name = "pod-app-secret-file"
                   },
               ]
           }
       }
     - default = {
         - build_dir      = "build"
         - manual_scaling = {
             - instances = 1
           }
         - root_dir       = "mcp"
         - runtime        = "java8"
       }
   } -> null
 - k8s_config_map       = {
     - app_1 = {
         - config_map = {
             - binary_data = {
                 - bar = "L3Jvb3QvMTAw"
               }
             - binary_file = [
                 - "../app_2/resources/binary.bin",
               ]
             - data        = {
                 - test = "test"
               }
             - data_file   = [
                 - "../app_2/resources/mosquitto.conf",
               ]
             - metadata    = {
                 - labels = {
                     - env = "test"
                   }
                 - name   = "mosquitto-config-file"
               }
           }
       }
   } -> null
 - k8s_file             = "../k8s.yml" -> null
 - kubernetes           = {
     - "components" = {
         - common = {
             - name = "name"
           }
         - specs  = {
             - app_1   = {
                 - config_map = {
                     - binary_data = {
                         - bar = "L3Jvb3QvMTAw"
                       }
                     - binary_file = [
                         - "../app_2/resources/binary.bin",
                       ]
                     - data        = {
                         - test = "test"
                       }
                     - data_file   = [
                         - "../app_2/resources/mosquitto.conf",
                       ]
                     - metadata    = {
                         - labels = {
                             - env = "test"
                           }
                         - name   = "mosquitto-config-file"
                       }
                   }
                 - deployment = {
                     - metadata = {
                         - labels    = {
                             - app = "mosquitto"
                           }
                         - name      = "mosquitto"
                         - namespace = null
                       }
                     - spec     = {
                         - replicas = 1
                         - selector = {
                             - match_labels = {
                                 - app = "mosquitto"
                               }
                           }
                         - template = {
                             - metadata = {
                                 - labels = {
                                     - app = "mosquitto"
                                   }
                               }
                             - spec     = {
                                 - container = [
                                     - {
                                         - image        = "eclipse-mosquitto:1.6.2"
                                         - name         = "mosquitto"
                                         - port         = [
                                             - {
                                                 - container_port = 1883
                                               },
                                           ]
                                         - resources    = {
                                             - limits   = {
                                                 - cpu    = "0.5"
                                                 - memory = "512Mi"
                                               }
                                             - requests = {
                                                 - cpu    = "250m"
                                                 - memory = "50Mi"
                                               }
                                           }
                                         - volume_mount = [
                                             - {
                                                 - mount_path = "/mosquitto/secret"
                                                 - name       = "mosquitto-secret-file"
                                               },
                                             - {
                                                 - mount_path = "mosquitto/config"
                                                 - name       = "mosquitto-config-file"
                                               },
                                           ]
                                       },
                                     - {
                                         - image     = "tomcat:8.5-jdk8-adoptopenjdk-openj9"
                                         - name      = "tomcat-example"
                                         - port      = [
                                             - {
                                                 - container_port = 8080
                                               },
                                           ]
                                         - resources = {
                                             - limits   = {
                                                 - cpu    = "0.5"
                                                 - memory = "512Mi"
                                               }
                                             - requests = {
                                                 - cpu    = "250m"
                                                 - memory = "50Mi"
                                               }
                                           }
                                       },
                                   ]
                                 - volume    = [
                                     - {
                                         - config_map = {
                                             - name = "mosquitto-config-file"
                                           }
                                         - name       = "mosquitto-config-file"
                                       },
                                     - {
                                         - name   = "mosquitto-secret-file"
                                         - secret = {
                                             - secret_name = "mosquitto-secret-file"
                                           }
                                       },
                                   ]
                               }
                           }
                       }
                   }
                 - secret     = {
                     - data      = {
                         - login    = "login"
                         - password = "password"
                       }
                     - data_file = [
                         - "../app_2/resources/secret.file",
                       ]
                     - metadata  = {
                         - annotations = {
                             - key1 = null
                             - key2 = null
                           }
                         - labels      = {
                             - env = "test"
                           }
                         - name        = "mosquitto-secret-file"
                         - namespace   = null
                       }
                     - type      = "Opaque"
                   }
                 - service    = {
                     - metadata = {
                         - generate_name = null
                         - labels        = {
                             - env = "test"
                           }
                         - name          = "mosquitto"
                         - namespace     = null
                       }
                     - spec     = {
                         - port     = [
                             - {
                                 - name        = "mosquitto-listener"
                                 - port        = 1883
                                 - target_port = 1883
                               },
                             - {
                                 - name        = "tomcat-listener"
                                 - port        = 80
                                 - target_port = 8080
                               },
                           ]
                         - selector = {
                             - app = "mosquitto"
                           }
                         - type     = "LoadBalancer"
                       }
                   }
               }
             - app_2   = {
                 - k8s_pod_autoscaler = {
                     - metadata = {
                         - name = "test"
                       }
                     - spec     = {
                         - max_replicas     = 100
                         - metric           = {
                             - external = {
                                 - metric = {
                                     - name     = "latency"
                                     - selector = {
                                         - match_labels = {
                                             - lb_name = "test"
                                           }
                                       }
                                   }
                                 - target = {
                                     - type  = "Value"
                                     - value = 100
                                   }
                               }
                             - type     = "External"
                           }
                         - min_replicas     = 50
                         - scale_target_ref = {
                             - kind = "Deployment"
                             - name = "MyApp"
                           }
                       }
                   }
                 - pod                = {
                     - metadata = {
                         - labels    = {
                             - app = "TestApp"
                           }
                         - name      = "nginx-example"
                         - namespace = null
                       }
                     - spec     = {
                         - container            = [
                             - {
                                 - image          = "nginx:1.7.8"
                                 - liveness_probe = {
                                     - http_get              = {
                                         - http_header = {
                                             - name  = "X-Custom-Header"
                                             - value = "Awesome"
                                           }
                                         - path        = "/"
                                         - port        = 80
                                       }
                                     - initial_delay_seconds = 3
                                     - period_seconds        = 3
                                   }
                                 - name           = "nginx-example"
                                 - port           = [
                                     - {
                                         - container_port = 8080
                                       },
                                   ]
                               },
                           ]
                         - dns_config           = {
                             - nameservers = [
                                 - "1.1.1.1",
                                 - "8.8.8.8",
                                 - "9.9.9.9",
                               ]
                             - option      = [
                                 - {
                                     - name  = "ndots"
                                     - value = 1
                                   },
                                 - {
                                     - name = "use-vc"
                                   },
                               ]
                             - searches    = [
                                 - "example.com",
                               ]
                           }
                         - dns_policy           = "None"
                         - env                  = {
                             - name  = "environment"
                             - value = "test"
                           }
                         - secret               = "pod-app-service-account-token-brds5"
                         - service_account_name = "pod-app-service-account"
                       }
                   }
                 - service_account    = {
                     - automount_service_account_token = true
                     - metadata                        = {
                         - name = "pod-app-service-account"
                       }
                     - secret                          = [
                         - {
                             - name = "pod-app-secret-file"
                           },
                       ]
                   }
               }
             - default = {
                 - build_dir      = "build"
                 - manual_scaling = {
                     - instances = 1
                   }
                 - root_dir       = "mcp"
                 - runtime        = "java8"
               }
           }
       }
   } -> null

Do you really want to destroy all resources?
 Terraform will destroy all your managed infrastructure, as shown above.
 There is no undo. Only 'yes' will be accepted to confirm.

 Enter a value: yes

module.mcp.kubernetes_config_map.self["app_1"]: Destroying... [id=default/mosquitto-config-file]
module.mcp.kubernetes_service_account.self["app_2"]: Destroying... [id=default/pod-app-service-account]
module.mcp.kubernetes_service.self["app_1"]: Destroying... [id=default/mosquitto]
module.mcp.kubernetes_secret.self["app_1"]: Destroying... [id=default/mosquitto-secret-file]
module.mcp.kubernetes_pod.self["app_2"]: Destroying... [id=default/nginx-example]
module.mcp.google_app_engine_application.self[0]: Destroying... [id=global-cluster-2]
module.mcp.google_storage_bucket_object.self["../app_1/build/helloworld/requirements.txt"]: Destroying... [id=global-cluster-2-570b1896080f7368d7a8737d020cfe252416d2c9]
module.mcp.google_app_engine_standard_app_version.self["default"]: Destroying... [id=apps/global-cluster-2/services/default/versions/1]
module.mcp.google_app_engine_application.self[0]: Destruction complete after 0s
module.mcp.kubernetes_deployment.self["app_1"]: Destroying... [id=default/mosquitto]
module.mcp.google_storage_bucket_object.self["../app_1/build/helloworld/main.py"]: Destroying... [id=global-cluster-2-6bcd5ab8b7d46f59780ba2497c112294220aa0cb]
module.mcp.google_cloud_run_service_iam_policy.self["default"]: Destroying... [id=v1/projects/global-cluster-2/locations/europe-west2/services/default]
module.mcp.kubernetes_secret.self["app_1"]: Destruction complete after 0s
module.mcp.kubernetes_config_map.self["app_1"]: Destruction complete after 0s
module.mcp.google_project_service.iam[0]: Destroying... [id=global-cluster-2/iam.googleapis.com]
module.mcp.google_project_service.iam[0]: Destruction complete after 0s
module.mcp.kubernetes_service_account.self["app_2"]: Destruction complete after 0s
module.mcp.kubernetes_deployment.self["app_1"]: Destruction complete after 0s
module.mcp.google_storage_bucket_object.self["../app_1/build/helloworld/requirements.txt"]: Destruction complete after 0s
module.mcp.google_storage_bucket_object.self["../app_1/build/helloworld/main.py"]: Destruction complete after 1s
module.mcp.google_cloud_run_service_iam_policy.self["default"]: Destruction complete after 1s
module.mcp.google_cloud_run_service.self["default"]: Destroying... [id=locations/europe-west2/namespaces/global-cluster-2/services/default]
module.mcp.google_cloud_run_service.self["default"]: Destruction complete after 0s
module.mcp.google_project_service.cloudrun[0]: Destroying... [id=global-cluster-2/run.googleapis.com]
module.mcp.kubernetes_pod.self["app_2"]: Destruction complete after 2s
module.mcp.kubernetes_service.self["app_1"]: Still destroying... [id=default/mosquitto, 10s elapsed]
module.mcp.google_project_service.cloudrun[0]: Still destroying... [id=global-cluster-2/run.googleapis.com, 10s elapsed]
module.mcp.kubernetes_service.self["app_1"]: Still destroying... [id=default/mosquitto, 20s elapsed]
module.mcp.kubernetes_service.self["app_1"]: Still destroying... [id=default/mosquitto, 30s elapsed]
module.mcp.kubernetes_service.self["app_1"]: Destruction complete after 36s

Error: Error when reading or editing Project Service global-cluster-2/run.googleapis.com: Error disabling service "run.googleapis.com" for project "global-cluster-2": Error waiting for api to disable: Error code 9, message: [Hook call/poll resulted in failed op for service 'run.googleapis.com': Please delete all resources before disabling the API.] with failed services [run.googleapis.com]



Error: Error when reading or editing AppVersion: googleapi: Error 400: Cannot delete the final version of a service (module). Please delete the whole service (module) in order to delete this version.


✘ dmitrogavrichuk@iMac-Dmitro  ~/DEVOPS/Mesoform/global_structure_test/terraform 
✘ dmitrogavrichuk@iMac-Dmitro  ~/DEVOPS/Mesoform/global_structure_test/terraform  terraform destroy
module.mcp.data.google_iam_policy.auth["default"]: Refreshing state...
module.mcp.data.google_project.self[0]: Refreshing state... [id=projects/global-cluster-2]
module.mcp.data.google_iam_policy.noauth["default"]: Refreshing state...
module.mcp.data.google_project.default[0]: Refreshing state... [id=projects/global-cluster-2]
module.mcp.google_project_service.std[0]: Refreshing state... [id=global-cluster-2/appengine.googleapis.com]
module.mcp.google_storage_bucket.self[0]: Refreshing state... [id=global-cluster-2]
module.mcp.google_project_service.cloudrun[0]: Refreshing state... [id=global-cluster-2/run.googleapis.com]
module.mcp.google_app_engine_standard_app_version.self["default"]: Refreshing state... [id=apps/global-cluster-2/services/default/versions/1]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
 - destroy

Terraform will perform the following actions:

 # module.mcp.google_app_engine_standard_app_version.self["default"] will be destroyed
 - resource "google_app_engine_standard_app_version" "self" {
     - delete_service_on_destroy = false -> null
     - env_variables             = {
         - "GCP_PROJECT_ID" = "global-cluster-2"
       } -> null
     - id                        = "apps/global-cluster-2/services/default/versions/1" -> null
     - inbound_services          = [] -> null
     - instance_class            = "F1" -> null
     - name                      = "apps/global-cluster-2/services/default/versions/1" -> null
     - noop_on_destroy           = false -> null
     - project                   = "global-cluster-2" -> null
     - runtime                   = "python37" -> null
     - service                   = "default" -> null
     - version_id                = "1" -> null

     - deployment {
         - files {
             - name       = "main.py" -> null
             - sha1_sum   = "6bcd5ab8b7d46f59780ba2497c112294220aa0cb" -> null
             - source_url = "https://storage.googleapis.com/global-cluster-2/6bcd5ab8b7d46f59780ba2497c112294220aa0cb" -> null
           }
         - files {
             - name       = "requirements.txt" -> null
             - sha1_sum   = "570b1896080f7368d7a8737d020cfe252416d2c9" -> null
             - source_url = "https://storage.googleapis.com/global-cluster-2/570b1896080f7368d7a8737d020cfe252416d2c9" -> null
           }
       }

     - entrypoint {
         - shell = "python main.py" -> null
       }

     - handlers {
         - auth_fail_action = "AUTH_FAIL_ACTION_REDIRECT" -> null
         - login            = "LOGIN_OPTIONAL" -> null
         - security_level   = "SECURE_OPTIONAL" -> null
         - url_regex        = ".*" -> null

         - script {
             - script_path = "auto" -> null
           }
       }
   }

 # module.mcp.google_project_service.cloudrun[0] will be destroyed
 - resource "google_project_service" "cloudrun" {
     - disable_dependent_services = true -> null
     - disable_on_destroy         = true -> null
     - id                         = "global-cluster-2/run.googleapis.com" -> null
     - project                    = "global-cluster-2" -> null
     - service                    = "run.googleapis.com" -> null
   }

 # module.mcp.google_project_service.std[0] will be destroyed
 - resource "google_project_service" "std" {
     - disable_dependent_services = true -> null
     - disable_on_destroy         = true -> null
     - id                         = "global-cluster-2/appengine.googleapis.com" -> null
     - project                    = "global-cluster-2" -> null
     - service                    = "appengine.googleapis.com" -> null
   }

 # module.mcp.google_storage_bucket.self[0] will be destroyed
 - resource "google_storage_bucket" "self" {
     - bucket_policy_only          = true -> null
     - default_event_based_hold    = false -> null
     - force_destroy               = true -> null
     - id                          = "global-cluster-2" -> null
     - labels                      = {
         - "billing" = "central"
       } -> null
     - location                    = "EUROPE-WEST2" -> null
     - name                        = "global-cluster-2" -> null
     - project                     = "global-cluster-2" -> null
     - requester_pays              = false -> null
     - self_link                   = "https://www.googleapis.com/storage/v1/b/global-cluster-2" -> null
     - storage_class               = "REGIONAL" -> null
     - uniform_bucket_level_access = true -> null
     - url                         = "gs://global-cluster-2" -> null

     - versioning {
         - enabled = true -> null
       }
   }

Plan: 0 to add, 0 to change, 4 to destroy.

Do you really want to destroy all resources?
 Terraform will destroy all your managed infrastructure, as shown above.
 There is no undo. Only 'yes' will be accepted to confirm.

 Enter a value: yes

module.mcp.google_project_service.cloudrun[0]: Destroying... [id=global-cluster-2/run.googleapis.com]
module.mcp.google_app_engine_standard_app_version.self["default"]: Destroying... [id=apps/global-cluster-2/services/default/versions/1]
module.mcp.google_project_service.cloudrun[0]: Still destroying... [id=global-cluster-2/run.googleapis.com, 10s elapsed]

Error: Error when reading or editing AppVersion: googleapi: Error 400: Cannot delete the final version of a service (module). Please delete the whole service (module) in order to delete this version.



Error: Error when reading or editing Project Service global-cluster-2/run.googleapis.com: Error disabling service "run.googleapis.com" for project "global-cluster-2": Error waiting for api to disable: Error code 9, message: [Hook call/poll resulted in failed op for service 'run.googleapis.com': Please delete all resources before disabling the API.] with failed services [run.googleapis.com]


✘ dmitrogavrichuk@iMac-Dmitro  ~/DEVOPS/Mesoform/global_structure_test/terraform 

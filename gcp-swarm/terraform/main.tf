/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

provider "google" {

  region  = var.region
  version = "~> 3.0"
}

provider "google-beta" {

  region  = var.region
  version = "~> 3.0"
}

module "vpc" {
    source  = "./modules/vpc"

    project_id   = var.project_id
    network_name = var.network_name

    shared_vpc_host = false
}

module "subnet" {
    source  = "./modules/subnets"

    project_id   = var.project_id
    network_name = module.vpc.network_name

    subnets = [
        {
            subnet_name           = "${module.vpc.network_name}-subnet"
            subnet_ip             = "10.154.0.0/20"
            subnet_region         = "europe-west2"
            subnet_private_access = "true"
            subnet_flow_logs      = "true"
            description           = "Docker Swarm subnet"
        }
    ]
}

locals {
  custom_rules = {
    allow-swarm-instances = {
      description = "Allow swarm instances comms and cluster management"
      direction = "INGRESS"
      action = "allow"
      ranges = ["0.0.0.0/0"]
      use_service_accounts = false
      # if `true` targets/sources expect list of instances SA, if false - list of tags
      targets = null
      # target_service_accounts or target_tags depends on `use_service_accounts` value
      sources = null
      # source_service_accounts or source_tags depends on `use_service_accounts` value
      rules = [
        {
          protocol = "tcp"
          ports = [
            "22",
            "2377",
            "5432",
            "7946",
            "8080",
            "30000-30010"]
        },
        {
          protocol = "udp"
          ports = [
            "7946",
            "4789"]
        },
        {
          protocol = "icmp"
          ports = []
        },
      ]

      extra_attributes = {
        priority = 1000
      }
    }
  }
}

module "firewall_rules" {
  source                  = "./modules/fabric-net-firewall"
  project_id              = var.project_id
  network                 = module.vpc.network_name
  internal_ranges_enabled = true
  internal_ranges         = [ module.subnet.subnets["${var.region}/${module.vpc.network_name}-subnet"].ip_cidr_range ]

  internal_allow = [
    {
      protocol = "icmp"
    },
    {
      protocol = "tcp"
    },
    {
      protocol = "udp"
    }
  ]
  custom_rules = local.custom_rules
}

module "instance_template" {
  source             = "./modules/instance_template"
  project_id         = var.project_id
  service_account    = var.service_account
  subnetwork         = module.subnet.subnets["${var.region}/${module.vpc.network_name}-subnet"].name
  subnetwork_project = var.project_id
  access_config      = [{ nat_ip = "", network_tier="STANDARD"}]
  metadata           = { ssh-keys = "${var.gcp_ssh_user}:${file(var.gcp_public_key_path)}" }
}

module "mig" {
  source            = "./modules/mig"
  project_id        = var.project_id
  region            = var.region
  target_size       = var.target_size
  hostname          = "mig-simple"
  instance_template = module.instance_template.self_link
}

data "google_compute_region_instance_group" "self_link" {
  self_link = module.mig.instance_group

  depends_on = [ module.mig.self_link ]
}

resource "null_resource" "wait" {

  provisioner "local-exec" {
    command = "while [ $(gcloud compute --project \"${var.project_id}\" instances list | grep \"RUNNING\" | wc -l) -lt ${var.target_size} ]; do sleep 5; done"
  }

  depends_on = [ module.mig ]
}

data "google_compute_instance" "instances" {
  count = var.target_size

  self_link = "${data.google_compute_region_instance_group.self_link.instances[count.index].instance}"

  depends_on = [ null_resource.wait ]
}

output "instances_internal_ips" {
  value = "${data.google_compute_instance.instances.*.network_interface.0.network_ip}"
}

output "instances_external_ips" {
  value = "${data.google_compute_instance.instances.*.network_interface.0.access_config.0.nat_ip}"
}

data "template_file" "inventory" {
  template = "${file("templates/inventory.tpl")}"

  depends_on = [ data.google_compute_instance.instances ]

  vars = {
    managers = "${join("\n", data.google_compute_instance.instances.*.network_interface.0.access_config.0.nat_ip)}"
  }
}

resource "null_resource" "cmd" {
  triggers = {
    template_rendered = "${data.template_file.inventory.rendered}"
  }

  provisioner "local-exec" {
    command = "echo '${data.template_file.inventory.rendered}' > ../ansible/inventory"
  }
}
# Google Projects Data

Takes a list of project IDs and looks them up on the platform and returns the details of those projects. The main 
purpose behind this module is to handle the situation where, when using the normal project data source, it can't be
depended upon, which means that when a project is removed from a list we're looking for details on, the data source 
needs to refresh first, and therefore Terraform has to be ran twice. Once to update the local state for the data source
and once to make the alteration on the dependant resource.

How to use

```terraform
module resources {
  source = "github.com/mesoform/terraform-infrastructure-modules/gcp/data/resource-manager/projects"
  project_ids = var.resources
}

```
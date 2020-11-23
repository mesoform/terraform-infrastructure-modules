terraform {
  backend "gcs" {
    bucket = "mcp-deployment-action-test"
    prefix = "terraform"
  }
}

module "mcp" {
  source = "../../../../../mcp"
}
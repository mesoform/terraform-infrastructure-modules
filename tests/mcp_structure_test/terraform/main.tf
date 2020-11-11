provider "kubernetes" {
  load_config_file = true
}

module "mcp" {
  source = "../mcp"
}

terraform {
  required_version = "0.12.13"
}
provider "google" {
  region      = "europe-west2"
  project = "mcp-testing-23452432"
  version = "2.20"
}

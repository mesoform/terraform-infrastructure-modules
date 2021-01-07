terraform{
  backend "gcs"{
    bucket = "gcs-bucket-name"
    prefix  = "tf-state-files"
  }
}

module "mcp" {
  source = "source-path"
}
terraform {
  required_version = "~> 1.7"
}
provider "google" {
  project = var.project_name
  region  = var.region
}

module "CloudSQL" {
  source = "./modules/CloudSQL"

  region          = var.region
  project_name    = var.project_name
  private_network = var.private_network
  env             = local.env
}
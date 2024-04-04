terraform {
  required_version = "~> 1.7"
}
provider "google" {
  project = var.project_id
  region  = var.region
}

module "CloudSQL" {
  source = "./modules/CloudSQL"

  private_network = var.private_network
  env             = local.env
}
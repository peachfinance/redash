terraform {
  required_version = "~> 1.7"
}

module "cloudsql" {
  source = "./modules/cloudsql"

  private_network = var.private_network
  env             = var.env
}
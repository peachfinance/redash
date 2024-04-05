locals {
  env = var.env != "" ? var.env : var.project_id
}

variable "project_id" {
  description = "The short id of the project"
  type        = string
}

variable "region" {
  description = "Main region for project"
  type        = string
  default     = "us-central-1"
}

variable "env" {
  type        = string
  description = "The environment the terraform resources will be used in."
  default     = "dev"
}

variable "private_network" {
  description = "The private network to attach to"
  type        = string
}
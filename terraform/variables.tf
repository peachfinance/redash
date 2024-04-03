locals {
  env = var.env != "" ? var.env : var.project_name
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "region" {
  description = "Main region for project"
  type        = string
  default     = "US-Central-1"
}

variable "env" {
  type        = string
  description = "The environment the terraform resources will be used in."
}

variable "private_network" {
  description = "The private network to attach to"
  type        = string
}
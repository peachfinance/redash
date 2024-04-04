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
  default     = "US-Central-1"
}

variable "env" {
  type        = string
  description = "By default the env name is the project_id. Use this to override"
  default     = ""
}

variable "private_network" {
  description = "The private network to attach to"
  type        = string
}
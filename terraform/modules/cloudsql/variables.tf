variable "env" {
  type        = string
  description = "The environment the terraform resources will be used in."
  default     = "dev"
}

variable "private_network" {
  description = "The private network to attach to"
  type        = string
}
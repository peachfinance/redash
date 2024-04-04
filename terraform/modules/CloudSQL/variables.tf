variable "env" {
  type        = string
  description = "By default the env name is the project_id. Use this to override"
  default     = ""
}

variable "private_network" {
  description = "The private network to attach to"
  type        = string
}
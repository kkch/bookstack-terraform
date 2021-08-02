variable "instance_id" {
  type        = string
  description = "Instance_id for the server"
}

variable "network_pool" {
  type        = string
  description = "network pool to use"
  default     = "public"
}

variable "server_name" {
  type        = string
  description = "Name of the server"
}

variable "key_pair_name" {
  type        = string
  description = "Name of the ssh Key to use in OpenStack"
}

variable "network_name" {
  type        = string
  description = "Network name to use in Openstack"
  default     = "private"
}

variable "security_group_name" {
  type        = list(string)
  description = "Security group name to use in Openstack"
  default     = ["SRE-SG"]
}

variable "flavor_name" {
  type        = string
  description = "Flavor name to use"
  default     = "sre.medium"
}

variable "image_id" {
  type        = string
  description = "Image id to use in openstack"
}
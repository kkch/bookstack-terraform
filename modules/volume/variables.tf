variable "volume_name" {
  type        = string
  description = "Name of the volume"
  default = "sre-bookstack-vol"
}

variable "volume_description" {
  type        = string
  description = "description for Volume"
  default = "Volume for SRE-Bookstack Data"
}

variable "volume_size" {
  type        = string
  description = "Volume size"
  default     = "10"
}


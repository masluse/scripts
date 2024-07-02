variable "name" {
  description = "The name of the VPC"
    type        = string
}

variable "tags" {
  description = "Tags to apply to Resources"
  type        = map(string)
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "subnets" {
  description = "The subnets to create in the VPC"
  type        = map(object({
    name = string
    cidr_block = string
    availability_zone = string
    map_public_ip_on_launch = bool
  }))
}
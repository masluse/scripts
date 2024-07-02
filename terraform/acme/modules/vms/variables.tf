variable "name" {
  description = "Name of the Virtual Machine"
  type        = string
}

variable "tags" {
  description = "Tags to apply to Resources"
  type        = map(string)
}

variable "ami_name" {
    description = "Name of the AMI to use for the Virtual Machine"
    type        = string
}

variable "instance_type" {
    description = "Type of the Virtual Machine"
    type        = string
}

variable "architecture" {
    description = "Architecture of the Virtual Machine"
    type        = string
}

variable "vpc" {
    description = "The name of the VPC to launch the Virtual Machine in"
    type        = string
}

variable "subnet" {
    description = "The name of the subnet to launch the Virtual Machine in"
    type        = string
}

variable "user_data" {
    description = "The path to the user data script to run on the Virtual Machine"
    type        = string
}

variable "key_name" {
    description = "The name of the key pair to use for the Virtual Machine"
    type        = string
}
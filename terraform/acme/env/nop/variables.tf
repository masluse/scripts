locals {
  tags = {
    Company = "BBW"
    Creator = "manuel.regli@lernende.bbw.ch"
    Owner   = "linus.rechsteiner@lernende.bbw.ch"
  }
}

variable "vms" {
  type = map(object({
    name = string
    ami_name = string
    instance_type = string
    architecture = string
    subnet = string
    vpc = string
    user_data = string
    key_name = string
  }))
  default = {
    vogelsrv1001 = {
      name = "vogelsrv1001"
      ami_name = "*ubuntu-noble-24.04*"
      instance_type = "t2.large"
      architecture = "x86_64"
      subnet = "vogelpubsub1001"
      vpc = "vogelvpc1001"
      key_name = "vockey"
      user_data = "../../scripts/vogelsrv1001.sh"
    }
  }
}

variable "vpc" {
  type = map(object({
    name = string
    cidr_block = string
    subnets = map(object({
      name = string
      cidr_block = string
      availability_zone = string
      map_public_ip_on_launch = bool
    }))
  }))
  default = {
    vogelvpc1001 = {
      name = "vogelvpc1001"
      cidr_block = "10.0.0.0/16"
      subnets = {
        vogelpubsub1001 = {
          name = "vogelpubsub1001"
          cidr_block = "10.0.1.0/24"
          availability_zone = "us-east-1a"
          map_public_ip_on_launch = true
        }
        vogelprivsub1001 = {
          name = "vogelprivsub1001"
          cidr_block = "10.0.2.0/24"
          availability_zone = "us-east-1a"
          map_public_ip_on_launch = false
        }
      }  
    }
  }
}
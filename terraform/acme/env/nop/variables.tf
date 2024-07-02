variable "vms" {
  type = map(object({
    name = string
    ami_name = string
    instance_type = string
    architecture = string
    public_ip = bool
    subnet = string
    vpc = string
    tags = map(string)
    user_data = string
  }))
  default = {
    vogelsrv1001 = {
      name = "vogelsrv1001"
      ami_name = "*ubuntu-noble-24.04*"
      instance_type = "t2.large"
      architecture = "x86_64"
      public_ip = true
      subnet = "vogelsub1001"
      vpc = "vogelvpc1001"
      user_data = "../../scripts/vogelsrv1001.sh"
      tags = {
          Company = "BBW"
          Creator = "manuel.regli@lernende.bbw.ch"
          Owner   = "linus.rechsteiner@lernende.bbw.ch"
      }
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
        vogelsub1001 = {
          name = "vogelsub1001"
          cidr_block = "10.0.1.0/24"
          availability_zone = "us-east-1a"
          map_public_ip_on_launch = true
        }
      }  
    }
  }
}
module "vms" {
    source = "../../modules/vms"
    for_each = var.vms
    name = each.value.name
    ami_name = each.value.ami_name
    instance_type = each.value.instance_type
    architecture = each.value.architecture
    public_ip = each.value.public_ip
    vpc = each.value.vpc
    subnet = each.value.subnet
    user_data = each.value.user_data
    depends_on = [ module.vpc ]
}

module "vpc" {
    source = "../../modules/vpc"
    for_each = var.vpc
    name = each.value.name
    cidr_block = each.value.cidr_block
    subnets = each.value.subnets
}
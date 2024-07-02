module "vms" {
    source = "../../modules/vms"
    for_each = var.vms
    name = each.value.name
    tags = local.tags
    ami_name = each.value.ami_name
    instance_type = each.value.instance_type
    architecture = each.value.architecture
    vpc = each.value.vpc
    subnet = each.value.subnet
    user_data = each.value.user_data
    key_name = each.value.key_name
    depends_on = [ module.vpc ]
}

module "vpc" {
    source = "../../modules/vpc"
    for_each = var.vpc
    name = each.value.name
    tags = local.tags
    cidr_block = each.value.cidr_block
    subnets = each.value.subnets
}
module "vpc" {
    source = "../../terraform-aws-vpc-advanced"
    cidr_block = var.cidr_block
    project_name = var.project_name
    common_tags = var.common_tags
    public_subnet_cidr = var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr
    database_subnet_cidr = var.database_subnet_cidr

    #peering configuration
    is_peering_enabled = "true"
    requester_vpc_id = data.aws_vpc.default.id
    default_route_table_id = data.aws_vpc.default.main_route_table_id
    default_vpc_cidr = data.aws_vpc.default.cidr_block
}
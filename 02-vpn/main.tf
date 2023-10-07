module "vpn_instance" {
    source  = "terraform-aws-modules/ec2-instance/aws"
    ami =    data.aws_ami.devops_ami.id 
    instance_type          = "t2.micro"
    vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
    # This is optional if we dont give this will be provisioned inside default subnet of default gateway
    # subnet_id              = local.public_subnet_ids[0]
    tags = merge(
        {
             Name = "Roboshop-Vpn"
        },
    var.common_tags
    )
    }
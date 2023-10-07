data "aws_ssm_parameter" "vpc_id" {

  name = "/${var.project_name}/${var.env}/vpc_id"
}

data "aws_ssm_parameter" "vpn_sg_id" {
  name = "/${var.project_name}/${var.env}/vpn_sg_id"
}

data "aws_ssm_parameter" "app_alb_sg_id" {
  name = "/${var.project_name}/${var.env}/app_alb_sg_id"
}

data "aws_ssm_parameter" "database_subnet_ids" {
   name = "/${var.project_name}/${var.env}/database_subnet_ids"
}

data "aws_ssm_parameter" "private_ip" {

  name = "/${var.project_name}/${var.env}/private_subnet_ids"
}
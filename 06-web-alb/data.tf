data "aws_ssm_parameter" "vpc_id" {

  name = "/${var.project_name}/${var.env}/vpc_id"
}

data "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/${var.project_name}/${var.env}/catalogue_sg_id"
}

data "aws_ssm_parameter" "web_alb_sg_id" {
  name = "/${var.project_name}/${var.env}/web_alb_sg_id"
}

data "aws_ssm_parameter" "public_ip" {
 name = "/${var.project_name}/${var.env}/public_subnet_ids"
}

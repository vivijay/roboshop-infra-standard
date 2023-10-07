module "web" {
  source = "../../terraform-roboshop-app"
  project_name = var.project_name
  env = var.env
  common_tags = var.common_tags

  #target group
  health_check = var.health_check
  target_group_port = var.target_group_port
  target_group_protocol = var.target_group_protocol
  vpc_id = data.aws_ssm_parameter.vpc_id.value

  # launch template
  image_id = data.aws_ami.devops_ami.id
  security_group_id = data.aws_ssm_parameter.web_sg_id.value
  user_data = filebase64("${path.module}/web.sh")
  launch_template_tags = var.launch_template_tags

  # Autoscaling
    vpc_zone_identifier = split(",",data.aws_ssm_parameter.private_ip.value)
  tag = var.autoscaling_tags

  #I am good autoscaling policy for default values  

alb_listener_arn = data.aws_ssm_parameter.web_alb_listener_arn.value
rule_priority = 10
host_header = "learndevcloud.online"

}
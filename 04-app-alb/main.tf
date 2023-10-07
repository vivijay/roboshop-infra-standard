resource "aws_lb" "app_alb" {
  name               = "${var.project_name}-${var.common_tags.Component}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.app_alb_sg_id.value]
  subnets            = split(",", data.aws_ssm_parameter.private_ip.value)

  tags = merge(
    {
          Name = "App-Alb"
  },
  var.common_tags
  )
   
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"
# This will add one listener on port 80 and one  default rule 
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content from APP ALB"
      status_code  = "200"
    }
  }
}
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = "learndevcloud.online"

  records = [
    {
      name    = "*.app"
      type    = "A"
      alias   = {
        name    = aws_lb.app_alb.dns_name
        zone_id = aws_lb.app_alb.zone_id
      }
    }
  ]
}
module "vpn_sg" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    sg_name = "roboshop-vpn"
    description = "Allow all the ports from my home IP"
   # sg_ingress_rules = var.sg_ingress_rules
    vpc_id = data.aws_vpc.default.id
    common_tags = merge(
        var.common_tags ,
        {
            Component = "VPN"
            Name = "VPN"
        }
    )
}

module "mongodb_sg" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    sg_name = "mongodb"
    description = "Allowing trafic"
   # sg_ingress_rules = var.sg_ingress_rules
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
        var.common_tags ,
        {
            Component = "MongoDb"
            Name = "MongoDb"
        }
    )
}
module "mysql_sg" {
  source = "../../terraform-aws-securitygroup"
  project_name = var.project_name
  sg_name = "mysql"
  description = "Allowing traffic"
  #sg_ingress_rules = var.sg_ingress_rules
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = merge(
    var.common_tags,
    {
        Component = "mysql",
        Name = "mysql"
    }
  )
}

module "rabbitmq_sg" {
  source = "../../terraform-aws-securitygroup"
  project_name = var.project_name
  sg_name = "rabbitmq"
  description = "Allowing traffic"
  #sg_ingress_rules = var.sg_ingress_rules
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = merge(
    var.common_tags,
    {
        Component = "rabbitmq",
        Name = "rabbitmq"
    }
  )
}

module "catalogue_sg" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    sg_name = "catalogue"
    description = "Allowing trafic"
   # sg_ingress_rules = var.sg_ingress_rules
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
        var.common_tags ,
        {
            Component = "Catalogue"
            Name = "Catalogue"
        }
    )
}

module "web_sg" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    sg_name = "web"
    description = "Allowing trafic"
   # sg_ingress_rules = var.sg_ingress_rules
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
        var.common_tags ,
        {
            Component = "Web"
            
        }
    )
}
module "app_alb_sg" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    sg_name = "App-ALB"
    description = "Allowing trafic"
   # sg_ingress_rules = var.sg_ingress_rules
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
        var.common_tags ,
        {
            Component = "App",
            Name = "App-ALB"

        }
    )
}
module "web_alb_sg" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    sg_name = "Web-ALB"
    description = "Allowing trafic"
   # sg_ingress_rules = var.sg_ingress_rules
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
        var.common_tags ,
        {
            Component = "Web",
            Name = "Web-ALB"

        }
    )
}
module "redis_sg" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    sg_name = "redis"
    description = "Allowing trafic"
   # sg_ingress_rules = var.sg_ingress_rules
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
        var.common_tags ,
        {
            Component = "redis",
            Name = "redis"

        }
    )
}
module "user_sg" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    sg_name = "user"
    description = "Allowing trafic"
   # sg_ingress_rules = var.sg_ingress_rules
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
        var.common_tags ,
        {
            Component = "user",
            Name = "user"

        }
    )
}
module "cart_sg" {
  source = "../../terraform-aws-securitygroup"
  project_name = var.project_name
  sg_name = "cart"
  description = "Allowing traffic"
  #sg_ingress_rules = var.sg_ingress_rules
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = merge(
    var.common_tags,
    {
        Component = "cart",
        Name = "cart"
    }
  )
}

module "shipping_sg" {
  source = "../../terraform-aws-securitygroup"
  project_name = var.project_name
  sg_name = "shipping"
  description = "Allowing traffic"
  #sg_ingress_rules = var.sg_ingress_rules
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = merge(
    var.common_tags,
    {
        Component = "shipping",
        Name = "shipping"
    }
  )
}

module "payment_sg" {
  source = "../../terraform-aws-securitygroup"
  project_name = var.project_name
  sg_name = "payment"
  description = "Allowing traffic"
  #sg_ingress_rules = var.sg_ingress_rules
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = merge(
    var.common_tags,
    {
        Component = "payment",
        Name = "payment"
    }
  )
}
resource "aws_security_group_rule" "vpn" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
#   ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.vpn_sg.security_group_id
}

# This is allowing connection from all catalogue instances to mongodb
resource "aws_security_group_rule" "mongodb_catalogue" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.catalogue_sg.security_group_id
#   ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.mongodb_sg.security_group_id
}

# This is allowing traffic from VPN on port no 22 for trouble shooting
resource "aws_security_group_rule" "mongodb_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
#   ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.mongodb_sg.security_group_id
}

resource "aws_security_group_rule" "catalogue_vpn" {
  type              = "ingress"
  description = "allowing port number 22 from VPN "
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
#   ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.catalogue_sg.security_group_id
}

resource "aws_security_group_rule" "catalogue_app_alb" {
  type              = "ingress"
  description = "allowing port number 8080 from App_alb"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb_sg.security_group_id
#   ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.catalogue_sg.security_group_id
}

resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  description = "allowing port number 80 from VPN"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
#   ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.app_alb_sg.security_group_id
}

resource "aws_security_group_rule" "app_alb_web" {
  type              = "ingress"
  description = "allowing port number 80 from Web"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_sg.security_group_id
#   ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.app_alb_sg.security_group_id
}

resource "aws_security_group_rule" "web_vpn" {
  type              = "ingress"
  description = "allowing port number 80 from VPN"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
#   ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.web_sg.security_group_id
}

resource "aws_security_group_rule" "web_vpn_ssh" {
  type              = "ingress"
  description = "allowing port number 22 from VPN"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
#   ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.web_sg.security_group_id
}

resource "aws_security_group_rule" "web_web_alb" {
  type              = "ingress"
  description = "allowing port number 80 from Web Alb"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_alb_sg.security_group_id
#   ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.web_sg.security_group_id
}
resource "aws_security_group_rule" "web_alb_internet" {
  type              = "ingress"
  description = "allowing port number 80 from Internet"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
#   ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.web_alb_sg.security_group_id
}
resource "aws_security_group_rule" "web_alb_internet_https" {
  type              = "ingress"
  description = "allowing port number 443 from Internet"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
#   ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.web_alb_sg.security_group_id
}
resource "aws_security_group_rule" "redis_user" {
  type              = "ingress"
  description = "allowing port number 6379 from User"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.user_sg.security_group_id
#   ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.redis_sg.security_group_id
}
resource "aws_security_group_rule" "redis_vpn" {
  type              = "ingress"
  description = "allowing port number 22 from VPn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
#   ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.redis_sg.security_group_id
}
resource "aws_security_group_rule" "redis_cart" {
  type              = "ingress"
  description = "Allowing port number 6379 from cart"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.cart_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.redis_sg.security_group_id
}
resource "aws_security_group_rule" "user_app_alb" {
  type              = "ingress"
  description = "allowing port number 8080 from APP Alb"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb_sg.security_group_id
#   ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.user_sg.security_group_id
}
resource "aws_security_group_rule" "user_vpn" {
  type              = "ingress"
  description = "allowing port number 22 from VPN"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
#   ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.user_sg.security_group_id
}
resource "aws_security_group_rule" "mongodb_user" {
  type              = "ingress"
  description = "allowing port number 27017 from VPN"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.user_sg.security_group_id
#   ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.mongodb_sg.security_group_id
}
resource "aws_security_group_rule" "mysql_vpn" {
  type              = "ingress"
  description = "Allowing port number 22 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.mysql_sg.security_group_id
}

resource "aws_security_group_rule" "mysql_shipping" {
  type              = "ingress"
  description = "Allowing port number 3306 from vpn"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.shipping_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.mysql_sg.security_group_id
}

resource "aws_security_group_rule" "rabbitmq_payment" {
  type              = "ingress"
  description = "Allowing port number 5672 from payment"
  from_port         = 5672
  to_port           = 5672
  protocol          = "tcp"
  source_security_group_id = module.payment_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.rabbitmq_sg.security_group_id
}

resource "aws_security_group_rule" "rabbitmq_vpn" {
  type              = "ingress"
  description = "Allowing port number 22 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.rabbitmq_sg.security_group_id
}
resource "aws_security_group_rule" "cart_vpn" {
  type              = "ingress"
  description = "Allowing port number 22 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.cart_sg.security_group_id
}

resource "aws_security_group_rule" "cart_app_alb" {
  type              = "ingress"
  description = "Allowing port number 8080 from APP ALB"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.cart_sg.security_group_id
}

resource "aws_security_group_rule" "shipping_vpn" {
  type              = "ingress"
  description = "Allowing port number 22 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.shipping_sg.security_group_id
}

resource "aws_security_group_rule" "shipping_app_alb" {
  type              = "ingress"
  description = "Allowing port number 8080 from APP ALB"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.shipping_sg.security_group_id
}

resource "aws_security_group_rule" "payment_vpn" {
  type              = "ingress"
  description = "Allowing port number 22 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.payment_sg.security_group_id
}

resource "aws_security_group_rule" "payment_app_alb" {
  type              = "ingress"
  description = "Allowing port number 22 from vpn"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.payment_sg.security_group_id
}
resource "aws_security_group_rule" "app_alb_catalogue" {
  type              = "ingress"
  description = "Allowing port number 80 from catalogue"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.catalogue_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.app_alb_sg.security_group_id
}

resource "aws_security_group_rule" "app_alb_user" {
  type              = "ingress"
  description = "Allowing port number 80 from user"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.user_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.app_alb_sg.security_group_id
}

resource "aws_security_group_rule" "app_alb_cart" {
  type              = "ingress"
  description = "Allowing port number 80 from cart"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.cart_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.app_alb_sg.security_group_id
}

resource "aws_security_group_rule" "app_alb_shipping" {
  type              = "ingress"
  description = "Allowing port number 80 from shipping"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.shipping_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.app_alb_sg.security_group_id
}

resource "aws_security_group_rule" "app_alb_payment" {
  type              = "ingress"
  description = "Allowing port number 80 from payment"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.payment_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.app_alb_sg.security_group_id
}

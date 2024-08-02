module "db" {
  source = "git::https://github.com/puneethtiruveedula/expense-sg-module.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  common_tags = var.common_tags
  sg_description = "SG for the DB MySQL Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "db"
}

module "backend" {
  source = "git::https://github.com/puneethtiruveedula/expense-sg-module.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  common_tags = var.common_tags
  sg_description = "SG for the Backend Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "backend"
}

module "app_alb" {
  source = "git::https://github.com/puneethtiruveedula/expense-sg-module.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  common_tags = var.common_tags
  sg_description = "SG for the app-alb Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "app-alb"
}

module "frontend" {
  source = "git::https://github.com/puneethtiruveedula/expense-sg-module.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  common_tags = var.common_tags
  sg_description = "SG for the Frontend Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "frontend"
}

module "web_alb" {
  source = "git::https://github.com/puneethtiruveedula/expense-sg-module.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  common_tags = var.common_tags
  sg_description = "SG for the web-alb Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "web-alb"
}
module "bastion" {
  source = "git::https://github.com/puneethtiruveedula/expense-sg-module.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  common_tags = var.common_tags
  sg_description = "SG for the Bastion Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "bastion"
}

module "vpn" {
  source = "git::https://github.com/puneethtiruveedula/expense-sg-module.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  common_tags = var.common_tags
  sg_description = "SG for the VPN Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "vpn"
  inbound_rules = var.vpn_sg_rules
}

# db security group rules
resource "aws_security_group_rule" "db_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend.sg_id # source is where you are getting traffic from
  security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "db_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "db_vpn" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.db.sg_id
}

# backend security group rules
resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_app_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb.sg_id
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_vpn_https" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backend.sg_id
}

# app_alb security group rules
resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.app_alb.sg_id
}

resource "aws_security_group_rule" "app_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.app_alb.sg_id
}

resource "aws_security_group_rule" "app_alb_frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id = module.app_alb.sg_id
}

# frontend security group rules
resource "aws_security_group_rule" "frontend_web_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_alb.sg_id
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.frontend.sg_id
}

# web_alb security group rules
resource "aws_security_group_rule" "web_alb_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.web_alb.sg_id
}

resource "aws_security_group_rule" "web_alb_public_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.web_alb.sg_id
}

# bastion security group rules
resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

#added as part of Jenkins CICD
resource "aws_security_group_rule" "backend_default_vpc" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["172.31.0.0/16"]
  security_group_id = module.backend.sg_id
}

#added as part of Jenkins CICD
resource "aws_security_group_rule" "frontend_default_vpc" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["172.31.0.0/16"]
  security_group_id = module.frontend.sg_id
}
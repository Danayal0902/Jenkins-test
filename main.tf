provider "aws" {
  region = "eu-west-1"
  
}

module "network" {
  source        = "./modules/network"
  owner         = "${var.owner}"
  purpose       = "${var.purpose}"
  environment   = "${var.environment}"
  vpc_cidr      = "${var.vpc_cidr}"
  subnet_count  = "${var.subnet_count[var.environment]}"
  anywhere_cidr = "${var.anywhere_cidr}"
}

module "sg" {
  source        = "./modules/sg"
  owner         = "${var.owner}"
  purpose       = "${var.purpose}"
  environment   = "${var.environment}"
  vpc_id        = "${module.network.vpc_id}"
  vpc_cidr      = "${var.vpc_cidr}"
  anywhere_cidr = "${var.anywhere_cidr}"
}

module "lb" {
  source        = "./modules/lb"
  owner         = "${var.owner}"
  purpose       = "${var.purpose}"
  environment   = "${var.environment}"
  vpc_id      = "${module.network.vpc_id}"

  public_instance_type     = "${var.public_instance_type}"
  public_security_group_id = "${module.sg.public_security_group_id}"
  public_subnet_ids        = "${module.network.public_subnet_ids}"
  public_key_path          = "${var.public_key_path}"
  aws_amis                 = "${var.aws_amis}"
  public_lb_security_group_id = "${module.sg.public_lb_security_group_id}"

}

module "db" {
  source      ="./modules/db"
  owner         = "${var.owner}"
  purpose       = "${var.purpose}"
  environment   = "${var.environment}"
  db_name       = "${var.db_name}"
  username      = "${var.username}"
  password      = "${var.password}"
  private_subnet_ids = "${module.network.private_subnet_ids}"
  private_security_group_id = "${module.sg.private_security_group_id}"
}


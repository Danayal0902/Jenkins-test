# More information: https://www.terraform.io/docs/providers/aws/index.html


# variable "aws_access_key" {
# }

# variable "aws_secret_key" {
# }

variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  default = "~/.ssh/id_rsa"
}

variable "aws_region" {
  default     = "eu-west-1"
}

variable "aws_amis" {
  default = "ami-674cbc1e"
  }


variable "db_name" {
  default     = "mydb"
  description = "db name"
}

variable "username" {
  default     = "myuser"
  description = "User name"
}

variable "password" {
	default = "deploy-strong-pwd"
  description = "password, provide through your ENV variables"
}

variable "environment" {
  description = "The environment of choice (dev, qa*, prod*)"
}

variable "owner" {
  description = "The owner of the resource (e.g. Who are you?)"
  default     = "cloudreach"
}

variable "purpose" {
  description = "The purpose of the resource (e.g. to pass butter)"
  default     = "part of cloud deploy vpc"
}

variable "anywhere_cidr" {
  default = "0.0.0.0/0"
}

variable "vpc_cidr" {
  description = "The CIDR of the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_count" {
  description = "The number of subnets required"
  type        = "map"

  default = {
    dev  = 2
    qa   = 2
    prod = 4
  }
}

variable "external_ip" {
  description = "The IP you are connecting from (e.g. the office external IP address)"
  default     = "185.73.154.30/32"
}


variable "public_instance_type" {
  description = "The instance type of the public instances"
  default     = "t2.micro"
}

variable "private_instance_type" {
  description = "The instance type of the private instances"
  default     = "t2.micro"
}
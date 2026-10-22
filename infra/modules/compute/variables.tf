variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "app_private_subnet_id" {
  type = string
}

variable "alb_security_group_id" {
  type = string
}

variable "app_security_group_id" {
  type = string
}

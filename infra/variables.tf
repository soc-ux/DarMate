variable "aws_region" {
  description = "Region AWS imposee pour le projet"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefixe du projet"
  type        = string
  default     = "darmate"
}

variable "vpc_cidr" {
  description = "Plage CIDR du VPC"
  type        = string
  default     = "10.0.0.0/16"
}

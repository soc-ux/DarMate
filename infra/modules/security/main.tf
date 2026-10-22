# 1. sg-alb : Inbound 80 depuis Internet
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-sg-alb"
  description = "Port 80 ouvert aux internautes"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound to anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "${var.project_name}-sg-alb" }
}

# 2. sg-front
resource "aws_security_group" "front" {
  name        = "${var.project_name}-sg-front"
  description = "Frontend accessible depuis ALB uniquement"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Outbound to anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "${var.project_name}-sg-front" }
}

# 3. sg-app : Inbound depuis sg-front uniquement
resource "aws_security_group" "app" {
  name        = "${var.project_name}-sg-app"
  description = "Backend accessible depuis le Frontend uniquement"
  vpc_id      = var.vpc_id

  ingress {
    description     = "API calls from Frontend only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.front.id] 
  }

  egress {
    description = "Outbound via NAT Gateway"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "${var.project_name}-sg-app" }
}

# 4. sg-db : Inbound 3306 depuis sg-app uniquement
resource "aws_security_group" "db" {
  name        = "${var.project_name}-sg-db"
  description = "MySQL autorise depuis sg-app uniquement"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL from Backend only"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  tags = { Name = "${var.project_name}-sg-db" }
}
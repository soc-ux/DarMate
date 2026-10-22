data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# ALB Public Multi-AZ
resource "aws_lb" "main" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids
  tags               = { Name = "${var.project_name}-alb" }
}

resource "aws_lb_target_group" "app" {
  name        = "${var.project_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

# Premiere instance EC2 (Sous-reseau prive, sans IP publique)
resource "aws_instance" "app_first" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"

  subnet_id              = var.app_private_subnet_id
  vpc_security_group_ids = [var.app_security_group_id]

  # Role IAM impose par AWS Academy
  iam_instance_profile = "LabInstanceProfile"

  metadata_options {
    http_tokens = "required"
  }

  user_data = <<-EOF
              #!/bin/bash
              dnf install -y httpd

              TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 300")
              META="http://169.254.169.254/latest/meta-data"
              AZ_NAME=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" $META/placement/availability-zone)
              INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" $META/instance-id)
              OUTBOUND_IP=$(curl -s --connect-timeout 5 https://checkip.amazonaws.com || echo "Erreur de connexion")

              cat <<HTML > /var/www/html/index.html
              <!DOCTYPE html>
              <html>
              <head>
                <meta charset="utf-8">
                <title>DarMate - Livrable 3</title>
                <style>
                  body { font-family: 'Segoe UI', Arial, sans-serif; background: #0f172a; color: #f8fafc; padding: 40px; }
                  .card { background: #1e293b; border-radius: 12px; padding: 30px; max-width: 650px; margin: auto; border: 1px solid #334155; }
                  h1 { color: #38bdf8; margin-top: 0; }
                  .badge { background: #16a34a; color: white; padding: 6px 14px; border-radius: 6px; font-weight: bold; font-size: 14px; }
                  .row { margin: 15px 0; font-size: 16px; }
                  .val { color: #facc15; font-family: monospace; font-size: 1.15em; font-weight: bold; }
                </style>
              </head>
              <body>
                <div class="card">
                  <h1>Hello</h1>
                  <p><span class="badge">EN LIGNE</span> Instance isolee dans le reseau prive</p>
                  <hr style="border-color: #334155;">
                  <div class="row">Instance ID : <span class="val">$${INSTANCE_ID}</span></div>
                  <div class="row">Zone de Disponibilite : <span class="val">$${AZ_NAME}</span></div>
                  <div class="row">IP Sortante (NAT Gateway) : <span class="val">$${OUTBOUND_IP}</span></div>
                  <p style="color: #94a3b8; font-size: 14px; margin-top: 25px;">
                    Cette instance n'a aucune adresse IP publique, recoit le trafic de l'ALB grace aux Security Groups chaines, et sort sur Internet via la NAT Gateway.
                  </p>
                </div>
              </body>
              </html>
              HTML

              systemctl start httpd
              systemctl enable httpd
              EOF

  tags = { Name = "${var.project_name}-first-instance" }
}

resource "aws_lb_target_group_attachment" "app_first" {
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.app_first.id
  port             = 80
}

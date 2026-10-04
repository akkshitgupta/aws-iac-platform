data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_launch_template" "app" {
  name_prefix   = "${var.environment}-app-"
  image_id      = data.aws_ssm_parameter.al2023_ami.value
  instance_type = var.instance_type

  vpc_security_group_ids = [
    var.security_group_id
  ]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y nginx
    systemctl enable nginx
    systemctl start nginx

    cat > /usr/share/nginx/html/index.html <<'HTML'
    <!DOCTYPE html>
    <html>
    <head>
      <title> ${var.environment} Platform</title>
    </head>
    <body>
      <h1> ${var.environment} application is running</h1>
      <p>Served by EC2 behind an Application Load Balancer.</p>
    </body>
    </html>
    HTML
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.environment}-app"
    }
  }
}

resource "aws_autoscaling_group" "app" {
  name = "${var.environment}-app-asg"

  min_size         = 1
  max_size         = 4
  desired_capacity = 1

  vpc_zone_identifier = var.private_subnet_ids

  target_group_arns = [
    var.target_group_arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-app"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "cpu_target" {
  name                   = "${var.environment}-app-cpu-target"
  autoscaling_group_name = aws_autoscaling_group.app.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}

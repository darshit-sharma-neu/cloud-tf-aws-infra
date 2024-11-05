resource "aws_launch_template" "launch_template" {
  name          = "webapp_launch_template"
  image_id      = var.ami_id
  instance_type = var.instance_type

  security_group_names = [var.app_security_group_name]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "webapp-autoscaling-instance"
    }
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  launch_template {
    id = aws_launch_template.launch_template.id
    version = "$Latest"
  }
}

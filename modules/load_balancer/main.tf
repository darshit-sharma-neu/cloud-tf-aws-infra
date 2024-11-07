resource "aws_lb" "load_balancer" {
  name               = var.load_balancer_name
  internal           = var.load_balancer_internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_groups
  subnets            = var.subnet_identifiers

  enable_deletion_protection = var.enable_deletion_protection

}

resource "aws_lb_target_group" "load_balancer_target_group" {
  name     = var.target_group_name
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id

  health_check {
    protocol            = var.health_check_protocol
    path                = var.health_check_path
    port                = var.health_check_port
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }
}

resource "aws_lb_listener" "load_balancer_listner" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.load_balancer_listner_port
  protocol          = var.load_balancer_listner_protocol

  default_action {
    type             = var.load_balancer_listner_default_action_type
    target_group_arn = aws_lb_target_group.load_balancer_target_group.arn
  }
}

#Create Auto Scaler
resource "aws_autoscaling_group" "autoscaler" {
  name = var.autosacler_name
  # Scaling Configuration
  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size

  # Launch Template Configuration
  launch_template {
    id      = var.launch_template_id
    version = "$Default"
  }

  # Network Configuration
  vpc_zone_identifier = var.subnet_identifiers
  target_group_arns   = var.target_group_arns


  # Health Check Configuration - TODO
  health_check_type = var.health_check_type

  # Tags
  tag {
    key                 = "Name"
    value               = var.autosacler_created_instance_name
    propagate_at_launch = true
  }
}

# Scaling Policies
resource "aws_autoscaling_policy" "scaling_up_policy" {
  name                   = "webapp-scaling-up-policy"
  scaling_adjustment     = var.autosacler_scale_up_scaling_adjustment
  adjustment_type        = var.autosacler_scale_up_scaling_adjustment_type
  cooldown               = var.autosacler_scale_up_scaling_cooldown
  autoscaling_group_name = aws_autoscaling_group.autoscaler.name

}

resource "aws_autoscaling_policy" "scaling_down_policy" {
  name                   = "webapp-scaling-down-policy"
  scaling_adjustment     = var.autosacler_scale_down_scaling_adjustment
  adjustment_type        = var.autosacler_scale_down_scaling_adjustment_type
  cooldown               = var.autosacler_scale_down_scaling_cooldown
  autoscaling_group_name = aws_autoscaling_group.autoscaler.name
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm_high" {
  alarm_name          = var.cpu_alarm_high_name
  comparison_operator = var.cpu_alarm_high_comparison_operator
  evaluation_periods  = var.cpu_alarm_high_evaluation_periods
  metric_name         = var.cpu_alarm_high_name_metric
  namespace           = var.cpu_alarm_high_namespace
  period              = var.cpu_alarm_high_period
  statistic           = var.cpu_alarm_high_statistic
  threshold           = var.cpu_alarm_high_threshold
  alarm_actions       = [aws_autoscaling_policy.scaling_up_policy.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.autoscaler.name
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm_low" {
  alarm_name          = var.cpu_alarm_low_name
  comparison_operator = var.cpu_alarm_low_comparison_operator
  evaluation_periods  = var.cpu_alarm_low_evaluation_periods
  metric_name         = var.cpu_alarm_low_name_metric
  namespace           = var.cpu_alarm_low_namespace
  period              = var.cpu_alarm_low_period
  statistic           = var.cpu_alarm_low_statistic
  threshold           = var.cpu_alarm_low_threshold
  alarm_actions       = [aws_autoscaling_policy.scaling_down_policy.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.autoscaler.name
  }
}
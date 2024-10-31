# create ec2 instance
resource "aws_instance" "instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  security_groups             = var.security_group_ids
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  disable_api_termination     = var.disable_api_termination
  iam_instance_profile        = var.iam_instance_profile
  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    delete_on_termination = var.delete_on_termination
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo mkdir -p /etc/systemd/system/webapp.service.d
    sudo tee /etc/systemd/system/webapp.service.d/env.conf > /dev/null <<EOL
    [Service]
    Environment=DB_HOST=${var.db_host}
    Environment=DB_USER=${var.db_username}
    Environment=DB_PASS=${var.db_password}
    Environment=DB_PORT=${var.db_port}
    Environment=DB_NAME=${var.db_name}
    Environment=BUCKET_NAME=${var.bucket_name}
    EOL

    cat <<EOT > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
    {
      "logs": {
        "logs_collected": {
          "files": {
            "collect_list": [
              {
                "file_path": "/home/webapp/logs/app.log",           
                "log_group_name": "${var.cloudwatch_logs_group_name}", 
                "log_stream_name": "{instance_id}", 
                "timestamp_format": "%Y-%m-%d %H:%M:%S"
              }
            ]
          }
        }
      },
      "metrics": {
        "namespace": "${var.cloudwatch_metric_namespace}",  
        "metrics_collected": {
          "statsd": {
            "service_address": ":8125"
          }
        }
      }
    }
    EOT

    sudo systemctl daemon-reload
    sudo systemctl restart amazon-cloudwatch-agent
  EOF
  tags = {
    Name = var.instance_name
  }
}

# Create Route 53 record to associate with the EC2 instances public IP
resource "aws_route53_record" "ec2_mapping" {
  depends_on = [aws_instance.instance]
  zone_id    = var.route53_zone_id
  name       = var.route53_record_name
  type       = var.route53_record_type
  ttl        = var.route53_record_ttl
  records    = [aws_instance.instance.public_ip]
}
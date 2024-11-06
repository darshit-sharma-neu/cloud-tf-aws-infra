# Create launch Template
resource "aws_launch_template" "webapp_launch_template" {
  
  name = "webapp_launch_template"
  description = "Webapp Launch Template"
  
  #Instance Configuration
  image_id = var.ami
  instance_type = var.instance_type
  disable_api_termination = var.disable_api_termination

  # Security Configuration
  security_group_names = var.security_group_names
  iam_instance_profile {
    name = var.iam_instance_profile
  }

  # Network Configuration
  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
  }

  # Storage Configuration
  block_device_mappings {
    ebs{
      volume_size = var.volume_size
      volume_type = var.volume_type
      delete_on_termination = var.delete_on_termination
    }
  }

  # User Data
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

  # Tagging
  tag_specifications {
    resource_type = "launch-template"
    tags = {
      Name = var.launch_template_name
    }
  }
}
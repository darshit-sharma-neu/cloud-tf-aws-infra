# create ec2 instance
resource "aws_instance" "instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  security_groups             = var.security_group_ids
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  disable_api_termination     = var.disable_api_termination
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
    EOL
    sudo systemctl daemon-reload
  EOF
  tags = {
    Name = var.instance_name
  }
}
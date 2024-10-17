# create security group
resource "aws_security_group" "webapp_security_group" {
  name = var.security_group_name
  description = var.security_group_description
  vpc_id = var.vpc_id

  ingress {
    description = "Allow SSH from anywhere"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description = "Allow HTTP from anywhere"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description = "Allow HTTPS from anywhere"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description = "Allow Application traffic from anywhere"
    from_port = var.app_port
    to_port = var.app_port
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    description = "Allow all traffic to anywhere"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = var.security_group_name
  }

}


# create ec2 instance
resource "aws_instance" "instance" {
  ami = var.ami
  instance_type = var.instance_type
  security_groups = [ aws_security_group.webapp_security_group.id ]
  subnet_id = var.subnet_id
  associate_public_ip_address = true
  tags = {
    Name = var.instance_name
  }
}
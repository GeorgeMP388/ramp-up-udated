data "aws_ami" "amz-ami" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#9 Create a Ubuntu server 1
resource "aws_instance" "Jump-box" {
  ami           = data.aws_ami.amz-ami.id
  instance_type = "t2.micro"
  key_name = var.key_name
  vpc_security_group_ids = [ aws_security_group.allow_jenkins.id ]
  subnet_id = aws_subnet.subnet-1.id
  user_data = <<-EOF
    #!/bin/bash
    amazon-linux-extras install epel docker  -y
    service docker start
    usermod -a -G docker ec2-user
    yum update
    wget -O /etc/yum.repos.d/jenkins.repo \
      https://pkg.jenkins.io/redhat-stable/jenkins.repo
    rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    yum upgrade -y
    yum install jenkins java-1.8.0-openjdk-devel -y
    usermod -aG docker jenkins
    systemctl daemon-reload
    systemctl start jenkins
    systemctl status jenkins
  EOF

  tags = merge(local.tags, {Name = "jenkins"})
}

#9.1 Create a Ubuntu server 2
resource "aws_instance" "front1" {
  ami           = data.aws_ami.amz-ami.id
  instance_type = "t2.micro"
  key_name = var.key_name
  vpc_security_group_ids = [ aws_security_group.allow_front.id ]
  subnet_id = aws_subnet.subnet-1.id
  user_data = local.frontend_user_data
  tags = merge(local.tags, {Name = "frontend"})
}


#9.2 Create a Ubuntu server 3
resource "aws_instance" "front2" {
  ami           = data.aws_ami.amz-ami.id
  instance_type = "t2.micro"
  key_name = var.key_name
  vpc_security_group_ids = [ aws_security_group.allow_front.id ]
  subnet_id = aws_subnet.subnet-2.id
  user_data = local.frontend_user_data
  tags = merge(local.tags, {Name = "frontend"})
}

#9.3 Create a Ubuntu server 4
resource "aws_instance" "backend" {
  ami           = data.aws_ami.amz-ami.id
  instance_type = "t2.micro"
  key_name = var.key_name
  vpc_security_group_ids = [ aws_security_group.allow_app.id ]
  subnet_id = aws_subnet.subnet-3.id
  tags = merge(local.tags, {Name = "backend"})
}



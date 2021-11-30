#9 Create a Ubuntu server 1
resource "aws_instance" "Jump-box" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
  key_name = "main-key"
  vpc_security_group_ids = [ aws_security_group.allow_jenkins.id ]
  subnet_id = aws_subnet.subnet-1.id
  user_data = <<-EOF
                    #!/bin/bash
                    sudo yum update –y
                    sudo wget -O /etc/yum.repos.d/jenkins.repo \
                    https://pkg.jenkins.io/redhat-stable/jenkins.repo
                    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
                    sudo yum upgrade
                    sudo yum install jenkins java-1.8.0-openjdk-devel -y
                    sudo systemctl daemon-reload
                    sudo systemctl start jenkins
                    sudo systemctl status jenkins
                    EOF
}

#9.1 Create a Ubuntu server 2
resource "aws_instance" "front1" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
  key_name = "internship-key"
  vpc_security_group_ids = [ aws_security_group.allow_front.id ]
  subnet_id = aws_subnet.subnet-1.id
}


#9.2 Create a Ubuntu server 3
resource "aws_instance" "front2" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
  key_name = "internship-key"
  vpc_security_group_ids = [ aws_security_group.allow_front.id ]
  subnet_id = aws_subnet.subnet-2.id
}

#9.3 Create a Ubuntu server 4
resource "aws_instance" "backend" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
  key_name = "internship-key"
  vpc_security_group_ids = [ aws_security_group.allow_app.id, aws_security_group.allow_jenkins.id ]
  subnet_id = aws_subnet.subnet-3.id
}



locals {
  tags = {
      Project   = "Internship"
      Year      = "2022"
      DU        = "BA"
  }
  jenkins_user_data = <<-EOF
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

  frontend_user_data = <<-EOF
    #!/bin/bash
    amazon-linux-extras install epel docker  -y
    service docker start
    usermod -a -G docker ec2-user
    yum update
    yum upgrade -y
    yum install java-1.8.0-openjdk-devel -y
    
  EOF
}
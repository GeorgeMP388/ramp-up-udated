 #1 Create a VPC
resource "aws_vpc" "ramp-vpc" {
  cidr_block = "10.0.0.0/16"
  tags ={
      Name = "Ramp-up"
  }
}

 #2 Create internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.ramp-vpc.id
  tags = {
    Name = "Ramp-gw"
  }
}

 #2.1 create NAT gwateway
resource "aws_eip" "nat-eip" {
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.subnet-1.id
  tags = {
    Name        = "nat"
  }
}

#3 Create custom route table public
resource "aws_route_table" "ramp-public-rout-table" {
  vpc_id = aws_vpc.ramp-vpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  route {
    ipv6_cidr_block        = "::/0"
    gateway_id= aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Ramp-public"
  }
}

#3.1 Create custom route table privet
resource "aws_route_table" "ramp-privet-rout-table" {
  vpc_id = aws_vpc.ramp-vpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "Ramp-privet"
  }
}

#4 Create  subnet 1
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.ramp-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${var.AWS_REGION}a" 
  tags = {
    Name = "Ramp-subnet1"
  }
}

 #4.1 Create subnet 2
resource "aws_subnet" "subnet-2" {
  vpc_id     = aws_vpc.ramp-vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${var.AWS_REGION}b"
  tags = {
    Name = "Ramp-subnet2"
  }
}

 #4.2 Create a Privet subnet
resource "aws_subnet" "subnet-3" {
  vpc_id     = aws_vpc.ramp-vpc.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = false
  availability_zone = "us-east-1a"
  tags = {
    Name = "Ramp-subnet3"
  }
}

 #5 Associate subnet with a route table
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.ramp-public-rout-table.id
}
 #5.1 Associate subnet with a route table
resource "aws_route_table_association" "privet" {
  subnet_id      = aws_subnet.subnet-3.id
  route_table_id = aws_route_table.ramp-privet-rout-table.id
}

#5.2 Associate subnet with a route table
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.ramp-public-rout-table.id
}

#6 create a load balance
resource "aws_lb" "ramp_lb" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_lb.id]
  subnets            = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]

  #enable_deletion_protection = true
  
  tags = {
    Environment = "ramp-lb"
  }
}

#  resource "aws_lb_listener" "front_end" {
#   load_balancer_arn = aws_lb.ramp_lb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.target_group.arn
#   }
#  }

#  resource "aws_lb_target_group_attachment" "lb_front1" {
#   target_group_arn = aws_lb_target_group.target_group.arn
#   target_id        = aws_instance.front1.id
#   port             = 80
# }

# resource "aws_lb_target_group_attachment" "lb_front2" {
#   target_group_arn = aws_lb_target_group.target_group.arn
#   target_id        = aws_instance.front2.id
#   port             = 80
# }

# resource "aws_lb_target_group" "target_group"{
#   name     = "tf-lb-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.ramp-vpc.id

# }
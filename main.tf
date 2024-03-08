
# STEP1: CREATING A SECURITY GROUP FOR JENKINS SERVER
# Description: Allow SSH, HTTP, HTTPS, 8080, 8081
resource "aws_security_group" "my_security_group1" {
  name        = "my-security-group1"
  description = "Allow SSH, HTTP, HTTPS, 8080 for Jenkins & Maven"

  # SSH Inbound Rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH Outbound Rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# STEP2: CREATE AN JENKINS EC2 INSTANCE USING EXISTING PEM KEY
# Note: i. First create a pem-key manually from the AWS console
#      ii. Copy it in the same directory as your terraform code
resource "aws_instance" "my_ec2_instance1" {
  ami                    = "ami-0f3c7d07486cad139"
  instance_type          = "t2.medium"
  vpc_security_group_ids = [aws_security_group.my_security_group1.id]
  #key_name               = "My_Key" # paste your key-name here, do not use extension '.pem'

  # Consider EBS volume 30GB
  root_block_device {
    volume_size = 15    # Volume size 30 GB
    volume_type = "gp2" # General Purpose SSD
  }

  tags = {
    Name = "Jenkins"
  }

  user_data = file("jenkins.sh")

}


# STEP3: OUTPUT PUBLIC IP OF EC2 INSTANCE
output "ACCESS_YOUR_JENKINS_HERE" {
  value = "http://${aws_instance.my_ec2_instance1.public_ip}:8080"
}

# STEP4: OUTPUT PUBLIC IP OF EC2 INSTANCE
output "MASTER_SERVER_PUBLIC_IP" {
  value = aws_instance.my_ec2_instance1.public_ip
}

# STEP5: OUTPUT PRIVATE IP OF EC2 INSTANCE
output "MASTER_SERVER_PRIVATE_IP" {
  value = aws_instance.my_ec2_instance1.private_ip
}

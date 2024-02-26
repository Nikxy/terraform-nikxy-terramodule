locals {
  ingress_traffic = [
    {
      port = "22"
      ip = "213.57.121.34/32"
    },
    {
      port = "80"
      ip = "0.0.0.0/0"
    },
    {
      port = "443"
      ip = "0.0.0.0/0"
    }
  ]
}

resource "aws_security_group" "my_sg" {
  name        = "allow-myssh-allhttp-s"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = "vpc-08d0690f631a02c74"
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  dynamic "ingress" {
    for_each = local.ingress_traffic
    content {
      from_port        = ingress.value["port"]
      to_port          = ingress.value["port"]
      protocol         = "tcp"
      cidr_blocks      = [ingress.value["ip"]]
    }
  }
}

output "sg_id" {
  value = aws_security_group.my_sg.id
}
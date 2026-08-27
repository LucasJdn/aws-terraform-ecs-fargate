output "vpc_id" {
  description = "ID from VPC"
  value = aws_vpc.Project.id
}

output "public_subnet_ids"{
    description = "Public Subnet Ids"
    value = [aws_subnet.Public01.id, aws_subnet.Public02.id]
}

output "private_subnet_ids"{
    description = "Private Subnet Ids"
    value = [aws_subnet.Private01.id, aws_subnet.Private02.id]
}


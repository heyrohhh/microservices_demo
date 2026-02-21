
output vpc_id {
     value = aws_vpc.main.id
}

output public_subnet_ids {
     value = [
               aws_subnet.public_subnet1.id,
               aws_subnet.public_subnet1a.id
     ]
}

output private_subnet_ids {
      value = [
            aws_subnet.private_subnet1.id,
            aws_subnet.private_subnet1a.id
      ]
}
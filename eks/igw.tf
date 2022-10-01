# # Creating internet gateway to enable resources in your VPC to communicate with the internet
# # Attach the internet gateway to your vpc


# resource "aws_internet_gateway" "main-gw" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name = "main"
#   }
# }
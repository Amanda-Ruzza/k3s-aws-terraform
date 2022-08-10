# --- compute/main.tf

data "aws_ami" "server_ami" {
  most_recent = true
  owners = ["898082745236"] #This is the Owner ID for the Ubuntu AMI

  filter {
    name = "name"
    values = ["Deep Learning AMI (Ubuntu 18.04)- *"] #The * is to make sure that every deployent will always get the latest AMI version
  }     
}
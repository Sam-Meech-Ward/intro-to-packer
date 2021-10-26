packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "cocktails" {
  ami_name = "cocktails-app-${local.timestamp}"

  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-2.*.1-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  # source_ami = "ami-013a129d325529d4d"


  instance_type = "t2.micro"
  region = "us-west-2"
  ssh_username = "ec2-user"
}

build {
  sources = [
    "source.amazon-ebs.cocktails"
  ]

  provisioner "file" {
    source = "../cocktails.zip"
    destination = "/home/ec2-user/cocktails.zip"
  }

  provisioner "file" {
    source = "./cocktails.service"
    destination = "/tmp/cocktails.service"
  }

  provisioner "shell" {
    script = "./app.sh"
  }
}
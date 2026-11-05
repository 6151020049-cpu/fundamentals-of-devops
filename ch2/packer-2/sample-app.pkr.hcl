
packer {
  required_plugins {
    amazon = {
      version = ">= 1.8.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# 1. Find the latest Amazon Linux 2023 base AMI
data "amazon-ami" "amazon-linux" {
  filters = {
    name                = "al2023-ami-2023.*-x86_64"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
    architecture        = "x86_64"
  }

  owners      = ["amazon"]
  most_recent = true
  region      = "ap-southeast-2"
  profile     = "dat-405398623290"
}

# 2. Define how Packer creates the custom AMI
source "amazon-ebs" "amazon-linux" {
  ami_name        = "sample-app-packer-${uuidv4()}"
  ami_description = "Amazon Linux 2023 AMI with Node.js sample app."

  instance_type = "t2.micro"
  region        = "ap-southeast-2"
  profile       = "dat-405398623290"

  source_ami   = data.amazon-ami.amazon-linux.id
  ssh_username = "ec2-user"

  tags = {
    Name        = "sample-app-packer"
    Project     = "Just Ship It"
    ManagedBy   = "Packer"
    Environment = "Lab"
  }

  run_tags = {
    Name      = "packer-builder-temporary"
    Project   = "Just Ship It"
    ManagedBy = "Packer"
  }
}

# 3. Build the custom AMI
build {
  sources = [
    "source.amazon-ebs.amazon-linux"
  ]

  # Copy application source code to the temporary EC2
  provisioner "file" {
    source      = "app.js"
    destination = "/home/ec2-user/app.js"
  }

  # Install Node.js on the temporary EC2
  provisioner "shell" {
    script       = "install-node.sh"
    pause_before = "30s"
  }

  # Verify that the application and runtime are present
  provisioner "shell" {
    inline = [
      "node --version",
      "test -f /home/ec2-user/app.js",
      "echo 'Packer provisioning completed successfully'"
    ]
  }
}


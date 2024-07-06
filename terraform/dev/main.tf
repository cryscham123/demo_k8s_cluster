# get the latest ubuntu image ami
data "aws_ami" "latest_ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_key_pair" "my_labtop" {
  key_name   = "my_labtop"
  public_key = file("~/.ssh/id_rsa.pub")
}

module "vpc" {
  source = "../modules/vpc"

  ENVIRONMENT   = var.ENVIRONMENT
  AWS_REGION    = var.AWS_REGION
  MASTER_INGRESS_RULES = [
    {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        security_groups = []
    },
    {
        from_port   = 6443
        to_port     = 6443
        protocol    = "tcp"
        cidr_blocks = []
        security_groups = [module.vpc.worker_sg_id]
    },
  ]
  WORKER_INGRESS_RULES = var.WORKER_INGRESS_RULES
}

resource "aws_instance" "master" {
  count = var.INSTANCE_MASTER_COUNT
  ami   = data.aws_ami.latest_ubuntu.id
  # k8s need at least 2 cpu and 4GB memory to run
  # but whatever?
  instance_type = "t2.micro"

  vpc_security_group_ids = [module.vpc.master_sg_id]
  subnet_id              = module.vpc.public_subnets

  key_name = aws_key_pair.my_labtop.key_name
  tags = {
    Name = "masterNode"
    ENV  = var.ENVIRONMENT
    OS   = "Ubuntu"
  }
}

resource "aws_instance" "worker" {
  count = var.INSTANCE_WORKER_COUNT
  ami   = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [module.vpc.worker_sg_id]
  subnet_id              = module.vpc.public_subnets

  key_name = aws_key_pair.my_labtop.key_name
  tags = {
    Name = "workerNode"
    ENV  = var.ENVIRONMENT
    OS   = "Ubuntu"
  }
}
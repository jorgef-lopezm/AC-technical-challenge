locals {
  prefix = "${var.project_name}-${terraform.workspace}"
  common_tags = {
    Module = "ec2"
  }
}

resource "aws_iam_role" "bastion_role" {
  name               = "${local.prefix}-bastion-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "bastion_policy_attachment" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${local.prefix}-bastion-instance-profile"
  role = aws_iam_role.bastion_role.name
}

resource "aws_instance" "bastion" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = "t3.micro"
  user_data            = templatefile(var.user_data_path, {})
  iam_instance_profile = aws_iam_instance_profile.bastion.name
  subnet_id            = var.public_subnet

  vpc_security_group_ids = var.security_groups

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}-bastion" }
  )
}
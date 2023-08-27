# Creating role for bastion host
resource "aws_iam_role" "bastion_role" {
  name               = "${local.prefix}-bastion-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = local.common_tags
}

# Attaching policy for pulling images from container registry
resource "aws_iam_role_policy_attachment" "bastion_role_policy_attachment" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Defining instance profile
resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name = "${local.prefix}-bastion-instance-profile"
  role = aws_iam_role.bastion_role.name
}

# Creating bastion host
resource "aws_instance" "bastion" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = "t3.micro"
  user_data            = templatefile(var.user_data_path, {})
  iam_instance_profile = aws_iam_instance_profile.bastion_instance_profile.name
  subnet_id            = var.subnet

  vpc_security_group_ids = var.security_groups

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}-bastion" }
  )
}
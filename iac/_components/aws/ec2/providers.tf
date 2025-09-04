provider "aws" {
  region = var.aws_region
  default_tags {
    tags = var.tags
  }
  dynamic "assume_role" {
    for_each = var.assume_role != null && var.assume_role != "" ? ["role"] : []
    content {
      role_arn = var.assume_role
    }
  }
}

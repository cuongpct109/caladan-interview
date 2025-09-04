
################################################################################
# Common Variables
################################################################################

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "additional_tags" {
  description = "Tags to add to the security group resource."
  type        = map(string)
  default     = {}
}

variable "master_prefix" {
  description = "To specify a key prefix for aws resource"
  type        = string
  default     = "dso"
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.master_prefix))
    error_message = "Valid values for variable: master_prefix cannot be empty."
  }
}

variable "aws_region" {
  description = "AWS Region name to deploy resources."
  type        = string
  default     = "ap-southeast-1"
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.aws_region))
    error_message = "Valid values for variable: must be valid AWS Region names. (ex: ap-southeast-1)"
  }
}

variable "assume_role" {
  description = "AssumeRole to manage the resources within account that owns"
  type        = string
  default     = null
  validation {
    condition     = var.assume_role != null ? can(regex("^arn:aws:iam::[[:digit:]]{12}:role/.+", var.assume_role)) : true
    error_message = "Valid values for variable: must be a valid AWS IAM role ARN. (ex: arn:aws:iam::111122223333:role/AWSAFTExecution)"
  }
}
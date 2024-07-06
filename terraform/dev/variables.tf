variable "AWS_REGION" {
  type        = string
  default     = "ap-northeast-2"
  description = "The region in which AWS resources will be created"
}

variable "ENVIRONMENT" {
  type    = string
  default = "DEV"
}

variable "INSTANCE_COUNT" {
  type        = number
  default     = 3
  description = "The number of instances to launch"
}
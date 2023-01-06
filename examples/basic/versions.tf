terraform {
  required_version = "~> 1.0"
  backend "local" {}
}

provider "aws" {
  default_tags {
    tags = {
      "ops/managed-by" = "terraform"
      example          = "aws/sns-topic/basic"
    }
  }
}

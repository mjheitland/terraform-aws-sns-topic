module "basic" {
  # to use GitHub as a source:
  # source = "git::https://mjheitland/terraform-aws-sns-topic?ref=1.0.0"

  # do not use this source -- local testing only
  source = "../../"

  name = "basic-example"
}

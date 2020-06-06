resource "aws_iot_thing" "thing2" {
  name = "thing2"
}

resource "aws_iot_certificate" "cert" {
  active = true
}

resource "aws_iot_policy_attachment" "att" {
  policy = data.terraform_remote_state.policy_data.outputs.pubsub_policy.name
  target = aws_iot_certificate.cert.arn
}

resource "aws_iot_thing_principal_attachment" "att" {
  principal = aws_iot_certificate.cert.arn
  thing     = aws_iot_thing.thing2.name
}

data "terraform_remote_state" "policy_data" {
  backend = "local"

  config = {
    path = "../terraform.tfstate"
  }
}

output "cert" {
  value = aws_iot_certificate.cert
}

output "thing2Arn" {
  value = aws_iot_thing.thing2.arn
}
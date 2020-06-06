resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "lambdaInGreengrassCore" {
  filename      = "./lambda/hello_world_python_lambda.zip"
  function_name = "lambdaInGreengrassCore"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "greengrassHelloWorld.function_handler"

  source_code_hash = filebase64sha256("./lambda/hello_world_python_lambda.zip")

  runtime = "python3.7"
}
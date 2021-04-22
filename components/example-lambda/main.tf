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
      "Effect": "Allow"
    }
  ]
}
EOF
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir = "${path.module}/source"
  output_path = "${path.module}/source.zip"
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "${data.archive_file.lambda_zip.output_path}"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  function_name = "hello-world"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.iam_for_lambda.arn
  runtime = "python3.8"
}
resource "aws_cloudwatch_log_group" "proxy" {
  name = format("%s-requests", var.api_display_name)
}

resource "aws_iam_role_policy" "sigvalid_api_gateway_log_write" {
  name   = format("%s_policy_log_write", var.api_display_name)
  role   = aws_iam_role.api_gateway_log_write.id
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
        ],
        Resource = aws_cloudwatch_log_group.proxy.arn
      },
      {
        Effect = "Allow",
        Action = [
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ],
        Resource = format("%s:log-stream:*", aws_cloudwatch_log_group.proxy.arn)
      }
    ]
  })
}

resource "aws_iam_role" "api_gateway_log_write" {
  name               = format("api-gateway-log-write-for-%s", var.api_display_name)
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "apigateway.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

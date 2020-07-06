resource "aws_cloudwatch_log_group" "codebuild_logs" {
  name = "/codebuild/ecs-pipeline"
}


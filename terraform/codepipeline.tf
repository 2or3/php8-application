variable "GITHUB_ACCOUNT" {}
variable "GITHUB_REPOSITORY" {}
variable "GITHUB_BRANCH" {}

data "aws_iam_policy_document" "codepipeline_assumerole" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codepipeline" {
  name               = "ecs-pipeline-project"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assumerole.json
}

resource "aws_iam_policy" "codepipeline" {
  name        = "ecs-pipeline-codepipeline"
  description = "ecs-pipeline-codepipeline"
  policy = templatefile("${path.root}/assets/codepipeline_policy.tpl", {
    artifacts = aws_s3_bucket.collarks_pipeline_artifact.id
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline" {
  role       = aws_iam_role.codepipeline.id
  policy_arn = aws_iam_policy.codepipeline.arn
}

resource "aws_codepipeline" "collarks_codepipeline" {
  name     = "collarks-ecs-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.collarks_pipeline_artifact.id
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      run_order        = 1
      output_artifacts = ["source"]
      configuration = {
        Owner  = "${var.GITHUB_ACCOUNT}"
        Repo   = "${var.GITHUB_REPOSITORY}"
        Branch = "${var.GITHUB_BRANCH}"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      run_order        = 2
      input_artifacts  = ["source"]
      output_artifacts = ["build"]
      configuration = {
        ProjectName = "collarks-ecs-pipeline"
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      version         = "1"
      run_order       = 3
      input_artifacts = ["build", "source"]
      configuration = {
        ApplicationName                = aws_codedeploy_app.collarks_deploy.name
        DeploymentGroupName            = aws_codedeploy_app.collarks_deploy.name
        TaskDefinitionTemplateArtifact = "source"
        TaskDefinitionTemplatePath     = "task_definition.json"
        AppSpecTemplateArtifact        = "source"
        AppSpecTemplatePath            = "appspec.yaml"
        Image1ArtifactName             = "build"
        Image1ContainerName            = "IMAGE1_NAME"
      }
    }
  }
}


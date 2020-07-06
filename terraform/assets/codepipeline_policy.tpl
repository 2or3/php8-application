{
    "Version": "2012-10-17",
        "Statement": [
        {
            "Action": [
                "iam:PassRole"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Condition": {
                "StringEqualsIfExists": {
                    "iam:PassedToService": [
                        "cloudformation.amazonaws.com",
                    "elasticbeanstalk.amazonaws.com",
                    "ec2.amazonaws.com",
                    "ecs-tasks.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Sid": "CodeBuildPolicy",
            "Effect": "Allow",
            "Action": [
                "codebuild:BatchGetBuilds",
            "codebuild:StartBuild"
            ],
            "Resource": "*"
        },
        {
            "Sid": "S3Policy",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::${artifacts}",
            "arn:aws:s3:::${artifacts}/*"
            ]
        },
        {
            "Action": [
                "codedeploy:CreateDeployment",
            "codedeploy:GetApplication",
            "codedeploy:GetApplicationRevision",
            "codedeploy:GetDeployment",
            "codedeploy:GetDeploymentConfig",
            "codedeploy:RegisterApplicationRevision"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "elasticloadbalancing:*",
            "cloudwatch:*",
            "sns:*",
            "ecs:*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "lambda:InvokeFunction",
            "lambda:ListFunctions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:DescribeImages"
            ],
            "Resource": "*"
        }
    ]
}


resource "aws_ecr_repository" "ecs_collarks" {
  name                 = "2or3/collarks"
  image_tag_mutability = "MUTABLE"
}


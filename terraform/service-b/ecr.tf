resource "aws_ecr_repository" "service_b" {
  name                 = local.name
  image_tag_mutability = "MUTABLE"
  force_delete         = true


  image_scanning_configuration {
    scan_on_push = true
  }
}

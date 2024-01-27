resource "aws_ecr_repository" "service_a" {
  name                 = "${local.name}-service-a"
  image_tag_mutability = "MUTABLE"
  force_delete = true


  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "service_b" {
  name                 = "${local.name}-service-b"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

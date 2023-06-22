resource "aws_ecr_repository" "trainer" {
  name                 = "container4ml-jupyter"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
}

resource "aws_ecr_repository" "predictor" {
  name                 = "container4ml-fastapi"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
}

# Push initial image which is built on local
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
resource "null_resource" "predictor" {
  provisioner "local-exec" {
    command     = <<EOT
        aws ecr get-login-password --region ${data.aws_region.current.name} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com
        docker push ${aws_ecr_repository.predictor.repository_url}:1.0
        docker push ${aws_ecr_repository.predictor.repository_url}:latest
    EOT
    interpreter = ["/bin/bash", "-c"]
    working_dir = path.module
  }
  depends_on = [aws_ecr_repository.predictor]
}

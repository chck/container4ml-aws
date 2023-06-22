variable "apprunner" {
  type = map(string)
  default = {
    name              = "apprunner-container4ml"
    auto_scaling_name = "AppRunnerDemo"
  }
}

resource "aws_iam_role" "apprunner4ecr" {
  name = "apprunner-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = [
            "build.apprunner.amazonaws.com",
            "tasks.apprunner.amazonaws.com"
          ]
        }
        Effect = "Allow"
      }
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
  ]
}

resource "time_sleep" "wait_create_roles" {
  create_duration = "5s"
  depends_on = [
    aws_iam_role.apprunner4ecr
  ]
}

resource "aws_apprunner_vpc_connector" "this" {
  vpc_connector_name = var.db.name
  subnets            = module.vpc.private_subnets
  security_groups    = [aws_security_group.allow_elasicache.id]
}

resource "aws_apprunner_auto_scaling_configuration_version" "this" {
  auto_scaling_configuration_name = var.apprunner.auto_scaling_name
  max_concurrency                 = 3
  max_size                        = 5
  min_size                        = 1
}


resource "aws_apprunner_service" "predictor" {
  service_name = var.apprunner.name
  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner4ecr.arn
    }
    image_repository {
      image_configuration {
        port = "80"
        runtime_environment_variables = {
          "REDISHOST" : aws_elasticache_replication_group.this.primary_endpoint_address
          "MODEL_NAME" : "A"
        }
      }
      image_identifier      = "${aws_ecr_repository.predictor.repository_url}:latest"
      image_repository_type = "ECR"
    }
  }
  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.this.arn
  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.this.arn
    }
  }
  depends_on = [
    time_sleep.wait_create_roles,
    aws_elasticache_replication_group.this,
    null_resource.predictor,
    aws_apprunner_auto_scaling_configuration_version.this
  ]
}

output "app_runner_url" {
  value = aws_apprunner_service.predictor.service_url
}

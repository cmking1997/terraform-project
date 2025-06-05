terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Amplify Frontend

resource "aws_amplify_app" "application_frontend" {
  name        = "application_frontend"
  repository  = var.frontend_repo
  oauth_token = var.github_token

  build_spec = <<-EOT
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - yarn install
        build:
          commands:
            - yarn run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  environment_variables = {
    ENV = "dev"
  }
}

# Lambda Microservice Backend

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = var.lambda_source
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "application_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_function_name"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.test"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs18.x"

  environment {
    variables = {
      ENV = "dev"
    }
  }
}

# S3 Storage

resource "aws_s3_bucket" "application_doc_storage" {
  bucket = "my-application-bucket"

  tags = {
    Name        = "App Doc Storage"
    Environment = "Dev"
  }
}

# RDS data storage

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "app_db"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "user"
  password             = "pass"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible  = false
}
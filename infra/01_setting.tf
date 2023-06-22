terraform {
  required_version = "~> 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.4.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
  }

  backend "s3" {
    bucket = "<YOU MUST EDIT THIS!!>"
    key    = "container4ml"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}

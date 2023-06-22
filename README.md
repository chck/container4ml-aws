# Container Tutorial for Machine Learning

## Prerequisites
| Software                   | Install (Mac)              |
|----------------------------|----------------------------|
| [Python 3.9.*][python]     | `pyenv install 3.9.16`     |
| [Poetry 1.5.*][poetry]     | `curl -sSL https://install.python-poetry.org \| python -` |
| [direnv][direnv]           | `brew install direnv`      |
| [Docker][docker]           | `brew cask install docker` |
| [AWS CLI][awscli]          | `brew install awscli`      |
| [kind][kind]               | `brew install kind`        |
| [hey][hey]                 | `brew install hey`         |
| [Terraform][terraform]     | `brew install terraform`   |

[python]: https://www.python.org/downloads/release/python-3916/
[poetry]: https://python-poetry.org/
[direnv]: https://direnv.net/
[docker]: https://docs.docker.com/docker-for-mac/
[awscli]: https://aws.amazon.com/cli/
[kind]: https://kind.sigs.k8s.io/
[hey]: https://github.com/rakyll/hey
[terraform]: https://www.terraform.io/


## Get Started
### Setup local environment
```bash
cp .env.example .env
```

Fill in your AWS resources.
```bash
${EDITOR} .env
=====================
AWS_BUCKET=
AWS_REGION=ap-northeast-1
AWS_ACCOUNT_ID=
USER=
TF_VAR_aws_bucket=${AWS_BUCKET}
TF_VAR_github_repo=chck/container4ml-aws
```

```bash
direnv allow .
```

### Create S3 bucket for tfstate
S3 Bucket needs to be unique, you should edit `AWS_BUCKET_TFSTATE` in [Makefile](https://github.com/chck/container4ml-aws/blob/main/Makefile#L1) and `backend.s3.bucket` in [infra/01_setting.tf](https://github.com/chck/container4ml-aws/blob/main/infra/01_setting.tf#L28).
```bash
$EDITOR Makefile
$EDITOR infra/01_setting.tf
make bucket
```

### Create AWS resources
```bash
cd infra
terraform init
terraform apply
```

## Clean up AWS resources
```bash
terraform destroy
```

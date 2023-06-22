AWS_BUCKET_TFSTATE:="<YOU MUST EDIT THIS!!>"

.PHONY: all
all: help

.PHONY: bucket  ## Create the bucket for terraform
bucket:
	# Create bucket
	aws s3api create-bucket --bucket=${AWS_BUCKET_TFSTATE} --region=${AWS_REGION} --create-bucket-configuration='LocationConstraint=${AWS_REGION}'
	# Enable versioning
	aws s3api put-bucket-versioning --bucket=${AWS_BUCKET_TFSTATE} --versioning-configuration Status=Enabled
	# Bucket encryption
	aws s3api put-bucket-encryption \
		--bucket ${AWS_BUCKET_TFSTATE} \
		--server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'
	# Block public access
	aws s3api put-public-access-block \
		--bucket ${AWS_BUCKET_TFSTATE} \
		--public-access-block-configuration '{"BlockPublicAcls": true, "IgnorePublicAcls": true, "BlockPublicPolicy": true, "RestrictPublicBuckets": true}'

.PHONY: help ## View help
help:
	@grep -E '^.PHONY: [a-zA-Z_-]+.*?## .*$$' $(MAKEFILE_LIST) | sed 's/^.PHONY: //g' | awk 'BEGIN {FS = "## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

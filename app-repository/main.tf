# Application Implementation
# Team: payment-api



# provision aws resources
resource "aws_s3_bucket" "app_storage" {
  bucket_prefix = "payment-api-data-"

  tags = {
    Environment = terraform.workspace
    ManagedBy   = "Vault-OIDC-Injected-Terraform"
    Application = "payment-api"
  }
}

resource "aws_s3_bucket_versioning" "app_storage" {
  bucket = aws_s3_bucket.app_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "app_key" {
  description             = "KMS key for Payment API S3 Bucket"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = {
    Application = "payment-api"
    Environment = terraform.workspace
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_storage" {
  bucket = aws_s3_bucket.app_storage.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.app_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "app_storage" {
  bucket                  = aws_s3_bucket.app_storage.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

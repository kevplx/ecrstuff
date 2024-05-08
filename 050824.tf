terraform {
  source = "terraform-aws-modules/s3-bucket/aws"
}

inputs = {
  name        = "my-s3-bucket"
  acl         = "private"
  versioning  = true
  force_destroy = true
  tags = {
    Environment = "Production"
    Project     = "MyProject"
  }
}

locals {
  root_folder       = "data/abc"
  variable_folders  = ["var1", "var2", "var3"]
  inbox_folder      = "inbox"
}

resource "aws_s3_bucket_object" "folder_objects" {
  bucket = module.s3_bucket.bucket_name
  acl    = "private"

  # Root folder
  content {
    key = "${local.root_folder}/"
  }

  # Create folders within 'FROM' directory
  dynamic "content" {
    for_each = { for idx, folder in local.variable_folders : idx => folder }
    content {
      key = "${local.root_folder}/FROM.${content.value}/"
    }
  }

  # Inbox folder
  content {
    key = "${local.root_folder}/${local.inbox_folder}/"
  }
}

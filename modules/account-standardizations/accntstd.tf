# Bucket Creation to store CFT YAML source code

resource "aws_s3_bucket" "hitech_buck" {
  bucket = "hitech-acc-std"
  acl    = "private"
}


# Adding CFT YAML source code into Above created S3 Bucket

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.hitech_buck.id
  key    = "account_std.yml"
  source = "/var/lib/jenkins/workspace/Jenkins-Terrafrom-CFT-pipeline/modules/account-standardizations/CFT/account_std.yml"

}


# CLOUDFORMATION CREATION 

resource "aws_cloudformation_stack" "acc_std" {
  depends_on = [aws_s3_bucket_object.object]
  name = "CFT-ACC-STD"
  disable_rollback = true
  parameters = {
    PermissionsBoundary = var.PermissionsBoundary
    AllowUsersToChangePassword = var.AllowUsersToChangePassword
    HardExpiry = var.HardExpiry
    MaxPasswordAge = var.MaxPasswordAge
    MinimumPasswordLength = var.MinimumPasswordLength
    PasswordReusePrevention = var.PasswordReusePrevention
    RequireLowercaseCharacters = var.RequireLowercaseCharacters
    RequireNumbers = var.RequireNumbers
    RequireSymbols = var.RequireSymbols
    RequireUppercaseCharacters = var.RequireUppercaseCharacters
    LogsRetentionInDays = var.LogsRetentionInDays
    
    }
 template_url = "https://${aws_s3_bucket.hitech_buck.id}.s3-us-west-2.amazonaws.com/account_std.yml"
}
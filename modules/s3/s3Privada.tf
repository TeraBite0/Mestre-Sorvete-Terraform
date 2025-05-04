resource "aws_s3_bucket" "s3_terabite_mestre_sorvete" {
  bucket = "terabite-mestre-sorvete"

  tags = {
    Name        = "Terabite Mestre Sorvete"
    Environment = "Dev"
  }
}

output "bucket_terabite_mestre_sorvete" {
  value = aws_s3_bucket.s3_terabite_mestre_sorvete.bucket
}
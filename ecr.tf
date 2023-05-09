
#ECRリポジトリの作成
resource "aws_ecr_repository" "default" {
  name                 = local.repository
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}
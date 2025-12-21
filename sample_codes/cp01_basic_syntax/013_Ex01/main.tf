data "archive_file" "multi_file_zip" {
  type        = "zip"
  source_dir  = "${path.module}/yogurts"
  output_path = "${path.module}/yogurts.zip"
}

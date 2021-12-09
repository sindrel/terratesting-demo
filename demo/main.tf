# Create a static page that serves something great
module "static_page" {
  source        = "./modules/static_page"
  project       = var.project
  bucket_name   = var.bucket_name
  bucket_suffix = var.bucket_suffix
}

output "page_url" {
  value = module.static_page.page_url
}
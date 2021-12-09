# Create a service that enables users to order autonomous flying cars
module "flying_cars_service" {
  source        = "./modules/flying_cars"
  project       = var.project
  bucket_name   = var.bucket_name
  bucket_suffix = var.bucket_suffix
}

output "page_url" {
  value = module.flying_cars_service.page_url
}
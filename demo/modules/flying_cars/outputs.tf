output "bucket_name" {
    value = google_storage_bucket.flying_cars.name
}

output "page_url" {
    value = "https://storage.googleapis.com/${google_storage_bucket.flying_cars.name}/index.html"
}

output "page_content" {
    value     = google_storage_bucket_object.index.content
    sensitive = true
}

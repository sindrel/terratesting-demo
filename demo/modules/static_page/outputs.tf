output "bucket_name" {
    value = google_storage_bucket.static_page.name
}

output "page_url" {
    value = "https://storage.googleapis.com/${google_storage_bucket.static_page.name}/index.html"
}

output "page_content" {
    value     = google_storage_bucket_object.index.content
    sensitive = true
}

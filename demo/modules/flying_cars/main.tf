# Create a storage bucket
resource "google_storage_bucket" "flying_cars" {
  project       = var.project
  name          = "${var.bucket_name}-${var.bucket_suffix}"
  location      = var.bucket_location
  force_destroy = true

  website {
    main_page_suffix = "health.html"
    not_found_page   = "health.html"
  }

  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}

# Set ACL policy to allow public access to bucket content
resource "google_storage_default_object_acl" "public_access" {
  bucket      = google_storage_bucket.flying_cars.name
  role_entity = var.role_entity
}

# Generate a random pet string
resource "random_pet" "favorite" {
  length    = 2
  separator = " "
}

# Create the landing page
resource "google_storage_bucket_object" "index" {
  bucket        = google_storage_bucket.flying_cars.name

  name          = "health.html"
  cache_control = "public, max-age=60"
  content       = "<h1>Autonomous flying car transport successfully ordered by a ${random_pet.favorite.id}.</h1>"
  
  depends_on = [
    google_storage_default_object_acl.public_access
  ]
}

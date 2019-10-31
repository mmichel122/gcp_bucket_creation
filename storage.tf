terraform {
  backend "remote" {
    organization = "modus-demo"
    workspaces {
      name = "gcp-bucket-qa-eu"
    }
  }
}

provider "google" {
  #credentials = "${file("./creds/serviceaccount.json")}"
  project = var.project_id
  region  = var.location
}

resource "google_storage_bucket" "web-store" {
  name     = "modus-demo-lab"
  location = "EU"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_storage_bucket_object" "files" {
  name   = "index.html"
  source = "./website/index.html"
  bucket = google_storage_bucket.web-store.name
}

resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.web-store.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_storage_default_object_acl" "object-acl" {
  bucket = google_storage_bucket.web-store.name
  object = google_storage_bucket_object.files.output_name
  role_entity = [
    "READER:allUsers",
  ]
}

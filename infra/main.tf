provider "google" {
  project = var.project_id
  region  =  var.region
  credentials = file("./cred-key.json")
}

# resource "google_service_account" "default" {
#   account_id   = "954868622910-compute@developer.gserviceaccount.com"
#   display_name = "Service Account"
# }

resource "google_container_cluster" "primary" {
  name               = "ashraf-cluster"
  location           = var.region
  initial_node_count = var.node_count
}
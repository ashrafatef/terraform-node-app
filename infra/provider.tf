provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file("./cred-key.json")
}


#data "google_container_cluster" "node_cluster" {
#  name     = "terraform-node-cluster"
#  location = var.region
#}

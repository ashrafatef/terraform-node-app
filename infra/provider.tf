provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file("./cred-key.json")
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
}


data "google_client_config" "default" {}
data "google_container_cluster" "my_cluster" {
  name     = "terraform-node-cluster"
  location = var.region
}

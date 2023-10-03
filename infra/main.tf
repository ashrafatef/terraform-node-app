provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file("./cred-key.json")
}

# resource "google_service_account" "default" {
#   account_id   = "954868622910-compute@developer.gserviceaccount.com"
#   display_name = "Service Account"
# }

resource "google_container_cluster" "primary" {
  name               = "terraform-node-cluster"
  location           = var.region

  node_pool {
    name = "default-pool"
    initial_node_count = 1
  }
}

## Container Registery 
resource "google_container_registry" "registry" {
  project  = var.project_id
  location = "EU"
}

resource "google_storage_bucket_iam_member" "owner" {
  bucket = google_container_registry.registry.id
  role   = "roles/storage.admin"
  member = "user:ashrafatef.de@gmail.com"
}

data "google_client_config" "default" {}
data "google_container_cluster" "my_cluster" {
  name     = "terraform-node-cluster"
  location = "EU"
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
}

resource "kubernetes_deployment_v1" "my_deployment" {
  metadata {
    name = "my-node-app"
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "my-node-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "my-node-app"
        }
      }

      spec {
        container {
          name  = "my-node-app"
          image = "eu.gcr.io/terraformpractice-400622/node-server:latest" #  Replace with your Docker image
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "my_service" {
  metadata {
    name = "my-node-app-service"
  }

  spec {
    selector = {
      app = "my-node-app"
    }

    port {
      protocol   = "TCP"
      port       = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}


# resource "tls_private_key" "self_signed_key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "tls_self_signed_cert" "self_signed_cert" {
#   private_key_pem = tls_private_key.self_signed_key.private_key_pem

#   validity_period_hours = 12
#   allowed_uses = []
# }
# resource "kubernetes_secret" "tls_secret" {
#   metadata {
#     name = "my-tls-secret"
#   }

#   data = {
#     crt = tls_self_signed_cert.self_signed_cert.cert_pem
#     key = tls_private_key.self_signed_key.private_key_pem
#   }
# }


resource "kubernetes_ingress" "my_ingress" {
  metadata {
    name = "my-node-app-ingress"
  }

  spec {
    rule {
      http {
        path {
          backend {
            service_name = kubernetes_service.my_service.metadata[0].name
            service_port = 80
          }
        }
      }
    }

    # tls {
    #   secret_name = kubernetes_secret.tls_secret.metadata[0].name
    # }
  }
}





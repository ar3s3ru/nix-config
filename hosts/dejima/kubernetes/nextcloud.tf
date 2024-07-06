resource "kubernetes_namespace" "nextcloud" {
  metadata {
    name = "nextcloud"
  }
}

resource "kubernetes_persistent_volume" "nextcloud" {
  metadata {
    name = "nextcloud-pv"
  }

  spec {
    storage_class_name = "local-path"
    access_modes       = ["ReadWriteOnce"]

    capacity = {
      storage = "1Ti"
    }

    persistent_volume_source {
      host_path {
        path = "/files/files"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "nextcloud" {
  metadata {
    name      = "nextcloud-pvc"
    namespace = kubernetes_namespace.nextcloud.metadata[0].name
  }

  spec {
    storage_class_name = kubernetes_persistent_volume.nextcloud.spec[0].storage_class_name
    access_modes       = kubernetes_persistent_volume.nextcloud.spec[0].access_modes

    resources {
      requests = {
        storage = "1Ti"
      }
    }
  }
}

resource "helm_release" "nextcloud" {
  name       = "nextcloud"
  repository = "https://nextcloud.github.io/helm/"
  chart      = "nextcloud"
  namespace  = kubernetes_namespace.nextcloud.metadata[0].name
  values     = [file("values-nextcloud.yaml")]
}

# NOTE: gotta create the ingress manually since the one packaged with Nextcloud
# Helm chart has hardcoded host name to `nextcloud.host`, and tailscale
# cannot accept its own MagicDNS hostname for reconciliation.
resource "kubernetes_ingress_v1" "nextcloud_tailscale" {
  depends_on = [helm_release.nextcloud]

  metadata {
    name      = "nextcloud"
    namespace = kubernetes_namespace.nextcloud.metadata[0].name
    labels = {
      "app.kubernetes.io/component" : "app"
      "app.kubernetes.io/instance" : "nextcloud"
      "app.kubernetes.io/name" : "nextcloud"
    }
  }

  spec {
    ingress_class_name = "tailscale"

    rule {
      host = "nextcloud"
      http {
        path {
          path = "/"
          backend {
            service {
              name = "nextcloud"
              port {
                number = 8080
              }
            }
          }
        }
      }
    }

    tls {
      hosts = ["nextcloud"]
    }
  }
}

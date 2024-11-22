resource "helm_release" "eck_operator" {
  name             = "eck-operator"
  repository       = "https://helm.elastic.co"
  chart            = "eck-operator"
  namespace        = "elastic-system"
  create_namespace = true

  values = [yamlencode({
    config = {
      # This will enable metrics exporting.
      metrics = {
        port       = "8081"
        secureMode = { enabled = true }
      }
    }

    serviceMonitor = {
      enabled = true
    }
  })]
}

resource "kubernetes_persistent_volume_v1" "elasticsearch" {
  metadata {
    name = "elasticsearch-pv"
  }

  spec {
    storage_class_name = "local-path"
    access_modes       = ["ReadWriteOnce"]

    capacity = {
      storage = "20Gi"
    }

    persistent_volume_source {
      host_path {
        path = "/files/flugg/elasticsearch"
      }
    }
  }
}

resource "helm_release" "eck_elasticsearch" {
  name             = "elasticsearch"
  repository       = "https://helm.elastic.co"
  chart            = "eck-elasticsearch"
  namespace        = "flugg-infra"
  create_namespace = true

  values = [yamlencode({
    ingress = {
      enabled   = true
      className = "tailscale"
      hosts = [
        {
          host   = "elasticsearch"
          prefix = "/"
        }
      ]
      tls = {
        enabled = true
      }
    }

    # We use Tailscale as ingress, which provides its own SSL certificate.
    # If we don't force Elasticsearch to use HTTP, then the Tailscale ingress won't work.
    http = {
      tls = {
        selfSignedCertificate = {
          disabled = true
        }
      }
    }

    nodeSets = [
      {
        name  = "default"
        count = 1

        config = {
          "node.store.allow_mmap" = false
        }

        podTemplate = {
          spec = {
            containers = [
              {
                name = "elasticsearch"
                resources = {
                  limits = {
                    memory = "1Gi"
                    cpu    = 1
                  }
                }
              }
            ]
          }
        }

        volumeClaimTemplates = [
          # NOTE(ar3s3ru): the volume has been patched manually on the filesystem
          # folder that backs up the PersistentVolume used here.
          #
          # chown -R 1000:1000 /files/flugg/elasticsearch
          {
            metadata = {
              name = "elasticsearch-data"
            }
            spec = {
              accessModes = ["ReadWriteOnce"]
              volumeName  = kubernetes_persistent_volume_v1.elasticsearch.metadata[0].name
              resources = {
                requests = {
                  storage = kubernetes_persistent_volume_v1.elasticsearch.spec[0].capacity.storage
                }
              }
            }
          }
        ]
      }
    ]
  })]
}

resource "helm_release" "eck_kibana" {
  name             = "kibana"
  repository       = "https://helm.elastic.co"
  chart            = "eck-kibana"
  namespace        = "flugg-infra"
  create_namespace = true

  depends_on = [
    helm_release.eck_elasticsearch
  ]

  values = [yamlencode({
    spec = {
      count = 1
      elasticsearchRef = {
        name      = "elasticsearch-eck-elasticsearch"
        namespace = "flugg-infra"
      }
      # We use Tailscale as ingress, which provides its own SSL certificate.
      # If we don't force Kibana to use HTTP, then the Tailscale ingress won't work.
      http = {
        tls = {
          selfSignedCertificate = {
            disabled = true
          }
        }
      }
    }
  })]
}

# NOTE: the Ingress has been created manually as the Ingress created
# by the eck-kibana chart is not really working with Tailscale.
resource "kubernetes_ingress_v1" "kibana" {
  depends_on = [helm_release.eck_kibana]

  metadata {
    name      = "kibana"
    namespace = "flugg-infra"
  }

  spec {
    default_backend {
      service {
        name = "kibana-eck-kibana-kb-http"
        port {
          number = 5601
        }
      }
    }

    ingress_class_name = "tailscale"

    tls {
      hosts = ["kibana"]
    }
  }
}

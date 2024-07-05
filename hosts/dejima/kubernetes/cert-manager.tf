resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  values = [
    file("values-cert-manager.yaml")
  ]
}

resource "kubernetes_secret" "cert_manager_cloudflare_api_token" {
  metadata {
    name      = "cloudflare-api-token"
    namespace = "cert-manager"
  }

  data = {
    api-token = var.cloudflare_api_token
  }
}

resource "kubernetes_manifest" "cert_manager_acme_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"

    metadata = {
      name = "acme"
    }

    spec = {
      acme = {
        email  = "danilocianfr+letsencrypt@gmail.com"
        server = "https://acme-v02.api.letsencrypt.org/directory"
        privateKeySecretRef = {
          name = "cert-manager-acme-issuer-account-key"
        }
        solvers = [{
          dns01 = {
            cloudflare = {
              apiTokenSecretRef = {
                name = kubernetes_secret.cert_manager_cloudflare_api_token.metadata[0].name
                key  = "api-token"
              }
            }
          }
        }]
      }
    }
  }
}

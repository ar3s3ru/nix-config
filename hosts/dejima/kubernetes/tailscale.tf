
resource "kubernetes_cluster_role_binding" "ar3s3ru_cluster_admin" {
  metadata {
    name = "ar3s3ru-cluster-admin"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "User"
    name      = "danilocianfr@gmail.com"
  }
}

resource "helm_release" "tailscale_operator" {
  name             = "tailscale-operator"
  repository       = "https://pkgs.tailscale.com/helmcharts"
  chart            = "tailscale-operator"
  namespace        = "networking"
  create_namespace = true

  values = [
    yamlencode({
      apiServerProxyConfig = {
        mode = "true"
      }
    })
  ]

  set_sensitive {
    name  = "oauth.clientId"
    value = var.tailscale_oauth_client_id
  }

  set_sensitive {
    name  = "oauth.clientSecret"
    value = var.tailscale_oauth_client_secret
  }
}

#XXX: These resources are both managed by Terraform here, and FLux to allow for
#XXX: successful initial cluster bootstraping

resource "kubernetes_namespace" "flux" {
  metadata {
    name = "flux-system"
  }

  lifecycle {
    # fluxcd manages these
    ignore_changes = [
      "metadata.0.labels",
      "metadata.0.annotations",
    ]
  }
}

resource "kubernetes_service_account" "flux-operator" {
  metadata {
    name      = "flux-operator"
    namespace = "${kubernetes_namespace.flux.metadata.0.name}"
  }

  lifecycle {
    # fluxcd manages these
    ignore_changes = [
      "metadata.0.labels",
      "metadata.0.annotations",
    ]
  }
}

resource "kubernetes_cluster_role" "flux-operator" {
  metadata {
    name = "flux-operator"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }

  rule {
    non_resource_urls = ["*"]
    verbs             = ["*"]
  }

  lifecycle {
    # fluxcd manages these
    ignore_changes = [
      "metadata.0.labels",
      "metadata.0.annotations",
    ]
  }
}

resource "kubernetes_cluster_role_binding" "flux-operator" {
  metadata {
    name = "flux-operator"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "flux-operator"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "flux-operator"
    namespace = "flux-system"
  }

  lifecycle {
    # fluxcd manages these
    ignore_changes = [
      "metadata.0.labels",
      "metadata.0.annotations",
    ]
  }
}

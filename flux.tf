resource "kubernetes_namespace" "flux" {
  metadata {
    name = "flux-system"
  }

  lifecycle {
    ignore_changes = [
        "metadata.0.labels",
        "metadata.0.annotations",
    ]
}
}


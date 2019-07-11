resource "null_resource" "cert_manager_setup" {
  depends_on = ["helm_release.nginx_ingress"]

  provisioner "local-exec" {
    command = "/bin/sh setup_cert_manager.sh"

  }
}

data "helm_repository" "jetstack" {
  name = "jetstack"
  url  = "https://charts.jetstack.io"
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "${data.helm_repository.jetstack.metadata.0.name}"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  wait       = "true"

  set {
    name  = "global.rbac.create"
    value = "true"
  }
  
  depends_on = ["null_resource.cert_manager_setup"]
}

resource "null_resource" "cluster_issuer_setup" {
    depends_on = ["helm_release.cert-manager"]

    provisioner "local-exec" {
    command = "/bin/sh setup_cert_issuer.sh "
    environment = {
        AZ_CERT_MANAGER_SP_PWD = "${var.client_secret}"
    }

  }
}


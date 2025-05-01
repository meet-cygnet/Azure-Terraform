resource "kubernetes_namespace" "agic" {
  metadata {
    name = var.namespace
  }
}

# resource "kubernetes_service_account" "agic" {
#   metadata {
#     name      = var.service_account_name
#     namespace = kubernetes_namespace.agic.metadata[0].name
#     annotations = {
#       "azure.workload.identity/client-id" = var.identity_client_id
#     }
#   }
# }

# resource "azurerm_federated_identity_credential" "agic" {
#   name                = var.federated_identity_credential_name
#   resource_group_name = var.resource_group_name
#   parent_id           = var.identity_client_id
#   audience            = ["api://AzureADTokenExchange"]
#   issuer              = data.azurerm_kubernetes_cluster.aks.oidc_issuer_url
#   subject             = "system:serviceaccount:${kubernetes_namespace.agic.metadata[0].name}:${var.service_account_name}"
# }

resource "helm_release" "agic" {
  name       = "ingress-azure"
  repository = "oci://mcr.microsoft.com/azure-application-gateway/charts"
  chart      = "ingress-azure"
  version    = var.agic_chart_version
  namespace  = kubernetes_namespace.agic.metadata[0].name

  set {
    name  = "appgw.name"
    value = var.app_gateway_name
  }

  set {
    name  = "appgw.resourceGroup"
    value = var.resource_group_name
  }

  set {
    name  = "appgw.subscriptionId"
    value = var.subscription_id
  }

  set {
    name  = "armAuth.type"
    value = "managedIdentity"
    # value = "workloadIdentity"
  }

  # set {
  #   name  = "armAuth.identityClientID"
  #   value = var.identity_client_id
  # }

  set {
    name  = "rbac.enabled"
    value = "true"
  }

  set {
    name  = "verbosityLevel"
    value = var.verbosity_level
  }

  set {
    name  = "reconcilePeriodSeconds"
    value = var.reconcile_period_seconds
  }

  # set {
  #   name  = "serviceAccount.name"
  #   value = var.service_account_name
  # }

  # set {
  #   name  = "serviceAccount.annotations.azure\\.workload\\.identity/client-id"
  #   value = var.identity_client_id
  # }

  # depends_on = [
  #   kubernetes_service_account.agic,
  #   azurerm_federated_identity_credential.agic
  # ]
} 
output "uami_client_id" {
    value = azurerm_user_assigned_identity.team_uami.client_id
    description = "Client ID of the UAMI to be used in pod annotations"
}

output "service_account_name" {
    value = ${var.team_name}-sa
    description = "Name of the Kubernetes ServiceAccount mapped to the FIC"

}

output "namespace" {
    value = "${var.team_name}-ns"
    description = "Namespace where the Service account is created"
}
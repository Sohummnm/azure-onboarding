
# This creates uami for the customer. 

resource "azurerm_user_assigned_identity" "team_uami" {
    name = "uami-${var.team_name}"
    resource_group_name = var.resource_group_name
    location =var.location
}

# This creates the federated identity credential

resource "azurerm_federated_identity_credential" "team_fic" {
    name = "fic-${var.team_name}"
    resource_group_name = var.resource_group_name
    parent_id = azurerm_user_assigned_identity.team_uami.id
    audience = ["api://AzureADTokenExchange"]
    issuer = local.oidc_issuer_url
    subject = "system:serviceaccount:${var.team_name}-ns:${var.team_name}-sa"
}
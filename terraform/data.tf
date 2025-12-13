data "terraform_remote_state" "aks" {
    backend = "azurerm"
    config = {
        resource_group_name = "rg-aks-platform"
        storage_account_name = "tfstateplatform"
        container_name = "aks"
        key = "aks-cluster.tfstate"
    }
}

locals {
    oidc_issuer_url = data.terraform_remote_state.aks.outputs.oidc_issuer_url
}
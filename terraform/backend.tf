terraform {
    backend "azurerm" {
        resource_group_name = "rg-terraform-state"
        storage_account_name = "tfstateplatform"
        container_name = "customer-onboard"
        key = "${var.team_name"}.tfstate
    }
}
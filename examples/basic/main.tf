terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-dev"
    storage_account_name = "stterraformstatestore"
    container_name       = "terraform-states"
    key                  = "alert-terraform.tfstate"
  }

  required_providers {
    azurerm = {
      version = "~> 3.64.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = "true"
  features {}
}

data "azurerm_resource_group" "rg_shared" {
  name = "rg-shared-dev"
}

data "azurerm_log_analytics_workspace" "log_shared" {
  name                = "log-shared-dev"
  resource_group_name = data.azurerm_resource_group.rg_shared.name
}

module "my_module" {
  source = "../.."

  resource_group_name = data.azurerm_resource_group.rg_shared.name
  location            = data.azurerm_resource_group.rg_shared.location
  tags                = {}

  action_groups = [
    {
      name            = "TestLoggingFailure"
      short_name      = "TestLogFail"
      email_receivers = [local.email_receiver_bwagner77, local.email_receiver_brianwagner777]
    }
  ]

  query_alert_rules = [
    {
      name                 = "sqr-logs-shared-dev"
      description          = "Alert when log count does not mee threshold"
      enabled              = false
      evaluation_frequency = "P1D"
      scope                = data.azurerm_log_analytics_workspace.log_shared.id
      severity             = 1
      window_duration      = "P1D"
      action_group_names   = ["IntPocLoggingFailure"]
      action_custom_properties = {
        "key1" = "test1"
        "key2" = "test2"
      }

      criteria = {
        operator                = "Equal"
        threshold               = 0
        time_aggregation_method = "Count"
        query                   = <<-QUERY
          FunctionAppLogs
          | where _ResourceId has "${data.azurerm_resource_group.rg_shared.name}" 
              and AppName == "TODO"
        QUERY
      }
    }
  ]
}

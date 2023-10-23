# Email receivers
locals {
  email_receiver_bwagner77 = {
    name          = "sendto-bwagner"
    email_address = "bwagner77@live.com"
  }
  email_receiver_brianwagner777 = {
    name          = "sendto-brianwagner777"
    email_address = "brian.wagner777@outlook.com"
  }
}

# Create alerts
module "alerts" {
  source = "git::https://github.com/brianwagner777/alert-module-2.git"

  resource_group_name = data.azurerm_resource_group.rg_shared.name
  location            = data.azurerm_resource_group.rg_shared.location
  tags                = local.tags

  action_groups = [
    {
      name            = "IntPocLoggingFailure"
      short_name      = "IntPocLogFail"
      email_receivers = [local.email_receiver_bwagner77, local.email_receiver_brianwagner777]
    }
  ]

  query_alert_rules = [
    {
      name                 = "sqr-logs-shared-${var.environment}"
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

  metric_alert_rules = [
    {
      name              = "sqr-metrics-shared-${var.environment}"
      description       = "Metric alert"
      enabled           = false
      frequency         = "P1D"
      scopes            = [data.azurerm_log_analytics_workspace.log_shared.id]
      severity          = 1
      window_size       = "P1D"
      action_group_name = "IntPocLoggingFailure"

      criteria = {
        metric_namespace = "Microsoft.Storage/storageAccounts"
        metric_name      = "Transactions"
        aggregation      = "Total"
        operator         = "GreaterThan"
        threshold        = 50
      }
    }
  ]
}

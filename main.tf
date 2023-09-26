# Create scheduled query alerts the Action Groups
resource "azurerm_monitor_action_group" "action_group" {
  count               = length(var.scheduled_query_alerts)
  resource_group_name = data.azurerm_resource_group.main.name
  name                = var.scheduled_query_alerts[count.index].action_group_name
  short_name          = substr(var.scheduled_query_alerts[count.index].action_group_short_name, 0, 12)
  tags                = var.tags

  dynamic "email_receiver" {
    for_each = var.scheduled_query_alerts[count.index].action_group_email_receivers
    content {
      name                    = email_receiver.value["name"]
      email_address           = email_receiver.value["email_address"]
      use_common_alert_schema = true
    }
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "alert_rule" {
  count               = length(var.scheduled_query_alerts)
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  description         = var.scheduled_query_alerts[count.index].alert_description
  enabled             = var.scheduled_query_alerts[count.index].alert_enabled
  display_name        = var.scheduled_query_alerts[count.index].alert_name
  tags                = var.tags

  auto_mitigation_enabled          = false
  workspace_alerts_storage_enabled = false
  skip_query_validation            = true
  action {
    action_groups = [azurerm_monitor_action_group.action_group[count.index].id]
  }

  lifecycle {
    ignore_changes = [
      enabled
    ]
  }
}

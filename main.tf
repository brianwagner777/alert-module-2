# Create scheduled query alerts the Action Groups
resource "azurerm_monitor_action_group" "action_group" {
  count               = length(var.scheduled_query_alerts)
  name                = var.scheduled_query_alerts[count.index].action_group_name
  resource_group_name = data.azurerm_resource_group.main.name
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

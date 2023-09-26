# Create scheduled query alerts the Action Groups
resource "azurerm_monitor_action_group" "action_group" {
  count               = length(var.scheduled_query_alerts)
  name                = var.scheduled_query_alerts[count.index].action_group_name
  resource_group_name = data.azurerm_resource_group.main.name
  short_name          = var.scheduled_query_alerts[count.index].action_group_short_name
  tags                = var.tags
}

# Create scheduled query alerts the Action Groups
resource "azurerm_monitor_action_group" "action_group" {
  for_each            = var.scheduled_query_alerts
  name                = each.value.action_group_name
  resource_group_name = data.azurerm_resource_group.main.name
  short_name          = each.value.action_group_short_name
  tags                = var.tags
}

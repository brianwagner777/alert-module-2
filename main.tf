# Create query alerts actions groups
resource "azurerm_monitor_action_group" "query_alert_action_groups" {
  count               = length(var.query_alerts)
  resource_group_name = var.resource_group_name
  name                = var.query_alerts[count.index].action_group_name
  short_name          = substr(var.query_alerts[count.index].action_group_short_name, 0, 12)
  tags                = var.tags

  dynamic "email_receiver" {
    for_each = var.query_alerts[count.index].action_group_email_receivers
    content {
      name                    = email_receiver.value["name"]
      email_address           = email_receiver.value["email_address"]
      use_common_alert_schema = true
    }
  }
}

# Create query alerts rules
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "query_alert_rules" {
  count               = length(var.query_alerts)
  name                = var.query_alerts[count.index].rule_name
  location            = var.location
  resource_group_name = var.resource_group_name
  description         = var.query_alerts[count.index].rule_description
  enabled             = var.query_alerts[count.index].rule_enabled
  display_name        = var.query_alerts[count.index].rule_name
  tags                = var.tags

  evaluation_frequency = var.query_alerts[count.index].rule_evaluation_frequency
  window_duration      = var.query_alerts[count.index].rule_window_duration
  scopes               = [var.query_alerts[count.index].rule_scope_resource_id]
  severity             = var.query_alerts[count.index].rule_severity
  criteria {
    query                   = var.query_alerts[count.index].rule_criteria_query
    time_aggregation_method = var.query_alerts[count.index].rule_criteria_time_aggregation_method
    threshold               = var.query_alerts[count.index].rule_criteria_threshold
    operator                = var.query_alerts[count.index].rule_criteria_operator
    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  auto_mitigation_enabled          = false
  workspace_alerts_storage_enabled = false
  skip_query_validation            = true
  action {
    action_groups = [azurerm_monitor_action_group.query_alert_action_groups[count.index].id]
  }

  lifecycle {
    ignore_changes = [
      enabled
    ]
  }
}

# Future
# Metrics alerts: azurerm_monitor_metric_alert
# Activity alerts: azurerm_monitor_activity_log_alert

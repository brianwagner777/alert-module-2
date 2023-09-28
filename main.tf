# Create query alerts actions groups
resource "azurerm_monitor_action_group" "query_alert_action_groups" {
  count               = length(var.query_alerts)
  resource_group_name = var.resource_group_name
  name                = var.query_alerts[count.index].action_group.name
  short_name          = substr(var.query_alerts[count.index].action_group.short_name, 0, 12)
  tags                = var.tags

  dynamic "email_receiver" {
    for_each = var.query_alerts[count.index].action_group.email_receivers
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
  name                = var.query_alerts[count.index].rule.name
  location            = var.location
  resource_group_name = var.resource_group_name
  description         = var.query_alerts[count.index].rule.description
  enabled             = var.query_alerts[count.index].rule.enabled
  display_name        = var.query_alerts[count.index].rule.name
  tags                = var.tags

  evaluation_frequency              = var.query_alerts[count.index].rule.evaluation_frequency
  scopes                            = var.query_alerts[count.index].rule.scopes
  severity                          = var.query_alerts[count.index].rule.severity
  window_duration                   = var.query_alerts[count.index].rule.window_duration
  auto_mitigation_enabled           = var.query_alerts[count.index].rule.auto_mitigation_enabled
  workspace_alerts_storage_enabled  = var.query_alerts[count.index].rule.workspace_alerts_storage_enabled
  mute_actions_after_alert_duration = var.query_alerts[count.index].rule.mute_actions_after_alert_duration
  query_time_range_override         = var.query_alerts[count.index].rule.query_time_range_override
  skip_query_validation             = var.query_alerts[count.index].rule.skip_query_validation
  target_resource_types             = var.query_alerts[count.index].rule.target_resource_types

  action {
    action_groups = [azurerm_monitor_action_group.query_alert_action_groups[count.index].id]
  }

  criteria {
    operator                = var.query_alerts[count.index].rule.criteria_operator
    query                   = var.query_alerts[count.index].rule.criteria_query
    threshold               = var.query_alerts[count.index].rule.criteria_threshold
    time_aggregation_method = var.query_alerts[count.index].rule.criteria_time_aggregation_method
    metric_measure_column   = var.query_alerts[count.index].rule.criteria_metric_measure_column
    resource_id_column      = var.query_alerts[count.index].rule.criteria_resource_id_column

    failing_periods {
      minimum_failing_periods_to_trigger_alert = var.query_alerts[count.index].rule.criteria_minimum_failing_periods_to_trigger_alert
      number_of_evaluation_periods             = var.query_alerts[count.index].rule.criteria_number_of_evaluation_periods
    }
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

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
  scopes                            = [var.query_alerts[count.index].rule.scope]
  severity                          = var.query_alerts[count.index].rule.severity
  window_duration                   = var.query_alerts[count.index].rule.window_duration
  auto_mitigation_enabled           = var.query_alerts[count.index].rule.auto_mitigation_enabled
  workspace_alerts_storage_enabled  = var.query_alerts[count.index].rule.workspace_alerts_storage_enabled
  mute_actions_after_alert_duration = var.query_alerts[count.index].rule.mute_actions_after_alert_duration
  query_time_range_override         = var.query_alerts[count.index].rule.query_time_range_override
  skip_query_validation             = var.query_alerts[count.index].rule.skip_query_validation
  target_resource_types             = var.query_alerts[count.index].rule.target_resource_types

  action {
    action_groups     = [azurerm_monitor_action_group.query_alert_action_groups[count.index].id]
    custom_properties = var.query_alerts[count.index].rule.action_custom_properties
  }

  criteria {
    operator                = var.query_alerts[count.index].rule.criteria.operator
    query                   = var.query_alerts[count.index].rule.criteria.query
    threshold               = var.query_alerts[count.index].rule.criteria.threshold
    time_aggregation_method = var.query_alerts[count.index].rule.criteria.time_aggregation_method
    metric_measure_column   = var.query_alerts[count.index].rule.criteria.metric_measure_column
    resource_id_column      = var.query_alerts[count.index].rule.criteria.resource_id_column

    dynamic "dimension" {
      for_each = var.query_alerts[count.index].rule.criteria.dimension[*]
      content {
        name     = var.query_alerts[count.index].rule.criteria.dimension.name
        operator = var.query_alerts[count.index].rule.criteria.dimension.operator
        values   = var.query_alerts[count.index].rule.criteria.dimension.values
      }
    }

    dynamic "failing_periods" {
      for_each = var.query_alerts[count.index].rule.criteria.failing_periods[*]
      content {
        minimum_failing_periods_to_trigger_alert = var.query_alerts[count.index].rule.criteria.failing_periods.minimum_failing_periods_to_trigger_alert
        number_of_evaluation_periods             = var.query_alerts[count.index].rule.criteria.failing_periods.number_of_evaluation_periods
      }
    }
  }

  lifecycle {
    ignore_changes = [
      enabled
    ]
  }
}

# Create metric alerts actions groups
resource "azurerm_monitor_action_group" "metric_alert_action_groups" {
  count               = length(var.metric_alerts)
  resource_group_name = var.resource_group_name
  name                = var.metric_alerts[count.index].action_group.name
  short_name          = substr(var.metric_alerts[count.index].action_group.short_name, 0, 12)
  tags                = var.tags

  dynamic "email_receiver" {
    for_each = var.metric_alerts[count.index].action_group.email_receivers
    content {
      name                    = email_receiver.value["name"]
      email_address           = email_receiver.value["email_address"]
      use_common_alert_schema = true
    }
  }
}

# Create metric alerts rules
resource "azurerm_monitor_metric_alert" "metric_alert_rules" {
  count               = length(var.metric_alerts)
  name                = var.metric_alerts[count.index].rule.name
  resource_group_name = var.resource_group_name
  description         = var.metric_alerts[count.index].rule.description
  enabled             = var.metric_alerts[count.index].rule.enabled
  tags                = var.tags

  scopes                   = var.metric_alerts[count.index].rule.scopes
  auto_mitigate            = var.metric_alerts[count.index].rule.auto_mitigate
  frequency                = var.metric_alerts[count.index].rule.frequency
  severity                 = var.metric_alerts[count.index].rule.severity
  target_resource_type     = var.metric_alerts[count.index].rule.target_resource_type
  target_resource_location = var.metric_alerts[count.index].rule.target_resource_location
  window_size              = var.metric_alerts[count.index].rule.window_size

  action {
    action_group_id    = azurerm_monitor_action_group.metric_alert_action_groups[count.index].id
    webhook_properties = var.metric_alerts[count.index].rule.action_webhook_properties
  }

  dynamic "criteria" {
    for_each = var.metric_alerts[count.index].rule.criteria[*]
    content {
      metric_namespace       = var.metric_alerts[count.index].rule.criteria.metric_namespace
      metric_name            = var.metric_alerts[count.index].rule.criteria.metric_name
      aggregation            = var.metric_alerts[count.index].rule.criteria.aggregation
      operator               = var.metric_alerts[count.index].rule.criteria.operator
      threshold              = var.metric_alerts[count.index].rule.criteria.threshold
      skip_metric_validation = var.metric_alerts[count.index].rule.criteria.skip_metric_validation

      dynamic "dimension" {
        for_each = var.metric_alerts[count.index].rule.criteria.dimension[*]
        content {
          name     = var.metric_alerts[count.index].rule.criteria.dimension.name
          operator = var.metric_alerts[count.index].rule.criteria.dimension.operator
          values   = var.metric_alerts[count.index].rule.criteria.dimension.values
        }
      }
    }
  }

  dynamic "dynamic_criteria" {
    for_each = var.metric_alerts[count.index].rule.dynamic_criteria[*]
    content {
      metric_namespace         = var.metric_alerts[count.index].rule.dynamic_criteria.metric_namespace
      metric_name              = var.metric_alerts[count.index].rule.dynamic_criteria.metric_name
      aggregation              = var.metric_alerts[count.index].rule.dynamic_criteria.aggregation
      operator                 = var.metric_alerts[count.index].rule.dynamic_criteria.operator
      alert_sensitivity        = var.metric_alerts[count.index].rule.dynamic_criteria.alert_sensitivity
      evaluation_total_count   = var.metric_alerts[count.index].rule.dynamic_criteria.evaluation_total_count
      evaluation_failure_count = var.metric_alerts[count.index].rule.dynamic_criteria.evaluation_failure_count
      ignore_data_before       = var.metric_alerts[count.index].rule.dynamic_criteria.ignore_data_before
      skip_metric_validation   = var.metric_alerts[count.index].rule.dynamic_criteria.skip_metric_validation

      dynamic "dimension" {
        for_each = var.metric_alerts[count.index].rule.dynamic_criteria.dimension[*]
        content {
          name     = var.metric_alerts[count.index].rule.dynamic_criteria.dimension.name
          operator = var.metric_alerts[count.index].rule.dynamic_criteria.dimension.operator
          values   = var.metric_alerts[count.index].rule.dynamic_criteria.dimension.values
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      enabled
    ]
  }
}

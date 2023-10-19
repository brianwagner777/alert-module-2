# Create actions groups
# https://stackoverflow.com/questions/58594506/how-to-for-each-through-a-listobjects-in-terraform-0-12
resource "azurerm_monitor_action_group" "action_groups" {
  for_each            = { for idx, ag in var.action_groups : ag.name => ag }
  resource_group_name = var.resource_group_name
  name                = each.value.name
  short_name          = substr(each.value.short_name, 0, 12)
  tags                = var.tags

  dynamic "email_receiver" {
    for_each = each.value.email_receivers
    content {
      name                    = email_receiver.value["name"]
      email_address           = email_receiver.value["email_address"]
      use_common_alert_schema = true
    }
  }
}

# Create query (log) alerts rules
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "query_alert_rules" {
  for_each            = { for idx, qar in var.query_alert_rules : qar.name => qar }
  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  description         = each.value.description
  enabled             = each.value.enabled
  display_name        = each.value.name
  tags                = var.tags

  evaluation_frequency              = each.value.evaluation_frequency
  scopes                            = [each.value.scope]
  severity                          = each.value.severity
  window_duration                   = each.value.window_duration
  auto_mitigation_enabled           = each.value.auto_mitigation_enabled
  workspace_alerts_storage_enabled  = each.value.workspace_alerts_storage_enabled
  mute_actions_after_alert_duration = each.value.mute_actions_after_alert_duration
  query_time_range_override         = each.value.query_time_range_override
  skip_query_validation             = each.value.skip_query_validation
  target_resource_types             = each.value.target_resource_types

  # https://build5nines.com/terraform-expression-get-list-object-by-attribute-value-lookup/
  # https://dev.to/pwd9000/terraform-filter-results-using-for-loops-4n75

  action {
    action_groups     = toset([for ag in azurerm_monitor_action_group.action_groups : ag.id if contains(each.value.action_group_names, ag.name)])
    custom_properties = each.value.action_custom_properties
  }

  criteria {
    operator                = each.value.criteria.operator
    query                   = each.value.criteria.query
    threshold               = each.value.criteria.threshold
    time_aggregation_method = each.value.criteria.time_aggregation_method
    metric_measure_column   = each.value.criteria.metric_measure_column
    resource_id_column      = each.value.criteria.resource_id_column

    dynamic "dimension" {
      for_each = each.value.criteria.dimension[*]
      content {
        name     = each.value.criteria.dimension.name
        operator = each.value.criteria.dimension.operator
        values   = each.value.criteria.dimension.values
      }
    }

    dynamic "failing_periods" {
      for_each = each.value.criteria.failing_periods[*]
      content {
        minimum_failing_periods_to_trigger_alert = each.value.criteria.failing_periods.minimum_failing_periods_to_trigger_alert
        number_of_evaluation_periods             = each.value.criteria.failing_periods.number_of_evaluation_periods
      }
    }
  }

  lifecycle {
    ignore_changes = [
      enabled
    ]
  }
}

# Create metric alert rules
resource "azurerm_monitor_metric_alert" "metric_alert_rules" {
  for_each            = { for idx, mar in var.metric_alert_rules : mar.name => mar }
  name                = each.value.rule.name
  resource_group_name = var.resource_group_name
  description         = each.value.rule.description
  enabled             = each.value.rule.enabled
  tags                = var.tags

  scopes                   = each.value.rule.scopes
  auto_mitigate            = each.value.rule.auto_mitigate
  frequency                = each.value.rule.frequency
  severity                 = each.value.rule.severity
  target_resource_type     = each.value.rule.target_resource_type
  target_resource_location = each.value.rule.target_resource_location
  window_size              = each.value.rule.window_size

  action {
    action_group_id    = toset([for ag in azurerm_monitor_action_group.action_groups : ag.id if each.value.action_group_names = ag.name])[0]
    webhook_properties = each.value.rule.action_webhook_properties
  }

  dynamic "criteria" {
    for_each = each.value.rule.criteria[*]
    content {
      metric_namespace       = each.value.rule.criteria.metric_namespace
      metric_name            = each.value.rule.criteria.metric_name
      aggregation            = each.value.rule.criteria.aggregation
      operator               = each.value.rule.criteria.operator
      threshold              = each.value.rule.criteria.threshold
      skip_metric_validation = each.value.rule.criteria.skip_metric_validation

      dynamic "dimension" {
        for_each = each.value.rule.criteria.dimension[*]
        content {
          name     = each.value.rule.criteria.dimension.name
          operator = each.value.rule.criteria.dimension.operator
          values   = each.value.rule.criteria.dimension.values
        }
      }
    }
  }

  dynamic "dynamic_criteria" {
    for_each = each.value.rule.dynamic_criteria[*]
    content {
      metric_namespace         = each.value.rule.dynamic_criteria.metric_namespace
      metric_name              = each.value.rule.dynamic_criteria.metric_name
      aggregation              = each.value.rule.dynamic_criteria.aggregation
      operator                 = each.value.rule.dynamic_criteria.operator
      alert_sensitivity        = each.value.rule.dynamic_criteria.alert_sensitivity
      evaluation_total_count   = each.value.rule.dynamic_criteria.evaluation_total_count
      evaluation_failure_count = each.value.rule.dynamic_criteria.evaluation_failure_count
      ignore_data_before       = each.value.rule.dynamic_criteria.ignore_data_before
      skip_metric_validation   = each.value.rule.dynamic_criteria.skip_metric_validation

      dynamic "dimension" {
        for_each = each.value.rule.dynamic_criteria.dimension[*]
        content {
          name     = each.value.rule.dynamic_criteria.dimension.name
          operator = each.value.rule.dynamic_criteria.dimension.operator
          values   = each.value.rule.dynamic_criteria.dimension.values
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

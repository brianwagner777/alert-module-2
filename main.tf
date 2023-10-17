# Create actions groups
resource "azurerm_monitor_action_group" "action_groups" {
  count               = length(var.action_groups)
  resource_group_name = var.resource_group_name
  name                = var.action_groups[count.index].name
  short_name          = substr(var.action_groups[count.index].short_name, 0, 12)
  tags                = var.tags

  dynamic "email_receiver" {
    for_each = var.action_groups[count.index].email_receivers
    content {
      name                    = email_receiver.value["name"]
      email_address           = email_receiver.value["email_address"]
      use_common_alert_schema = true
    }
  }
}

# Create query alerts rules
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "query_alert_rules" {
  count               = length(var.query_alert_rules)
  name                = var.query_alert_rules[count.index].name
  location            = var.location
  resource_group_name = var.resource_group_name
  description         = var.query_alert_rules[count.index].description
  enabled             = var.query_alert_rules[count.index].enabled
  display_name        = var.query_alert_rules[count.index].name
  tags                = var.tags

  evaluation_frequency              = var.query_alert_rules[count.index].evaluation_frequency
  scopes                            = [var.query_alert_rules[count.index].scope]
  severity                          = var.query_alert_rules[count.index].severity
  window_duration                   = var.query_alert_rules[count.index].window_duration
  auto_mitigation_enabled           = var.query_alert_rules[count.index].auto_mitigation_enabled
  workspace_alerts_storage_enabled  = var.query_alert_rules[count.index].workspace_alerts_storage_enabled
  mute_actions_after_alert_duration = var.query_alert_rules[count.index].mute_actions_after_alert_duration
  query_time_range_override         = var.query_alert_rules[count.index].query_time_range_override
  skip_query_validation             = var.query_alert_rules[count.index].skip_query_validation
  target_resource_types             = var.query_alert_rules[count.index].target_resource_types

  # https://build5nines.com/terraform-expression-get-list-object-by-attribute-value-lookup/

  action {
    action_groups     = toset([for each in azurerm_monitor_action_group.action_groups : each.id if each.name == var.query_alert_rules[count.index].action_group_name])
    custom_properties = var.query_alert_rules[count.index].action_custom_properties
  }

  criteria {
    operator                = var.query_alert_rules[count.index].criteria.operator
    query                   = var.query_alert_rules[count.index].criteria.query
    threshold               = var.query_alert_rules[count.index].criteria.threshold
    time_aggregation_method = var.query_alert_rules[count.index].criteria.time_aggregation_method
    metric_measure_column   = var.query_alert_rules[count.index].criteria.metric_measure_column
    resource_id_column      = var.query_alert_rules[count.index].criteria.resource_id_column

    dynamic "dimension" {
      for_each = var.query_alert_rules[count.index].criteria.dimension[*]
      content {
        name     = var.query_alert_rules[count.index].criteria.dimension.name
        operator = var.query_alert_rules[count.index].criteria.dimension.operator
        values   = var.query_alert_rules[count.index].criteria.dimension.values
      }
    }

    dynamic "failing_periods" {
      for_each = var.query_alert_rules[count.index].criteria.failing_periods[*]
      content {
        minimum_failing_periods_to_trigger_alert = var.query_alert_rules[count.index].criteria.failing_periods.minimum_failing_periods_to_trigger_alert
        number_of_evaluation_periods             = var.query_alert_rules[count.index].criteria.failing_periods.number_of_evaluation_periods
      }
    }
  }

  lifecycle {
    ignore_changes = [
      enabled
    ]
  }
}

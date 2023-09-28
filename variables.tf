variable "resource_group_name" {
  description = "Name of the resource group where the resources will be created."
  type        = string
}

variable "location" {
  description = "Location where the resources will be created."
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all created resources."
  default     = {}
}

variable "query_alerts" {
  type = list(object({
    action_group = object({
      name            = string,
      short_name      = string,
      email_receivers = list(object({ name = string, email_address = string })),
    }),
    rule = object({
      name                              = string,
      description                       = optional(string),
      enabled                           = bool,
      evaluation_frequency              = string,
      scopes                            = set(string),
      severity                          = number,
      window_duration                   = string,
      auto_mitigation_enabled           = optional(bool, false),
      workspace_alerts_storage_enabled  = optional(bool, false),
      mute_actions_after_alert_duration = optional(string),
      query_time_range_override         = optional(string),
      skip_query_validation             = optional(bool, false),
      target_resource_types             = optional(set(string)),

      criteria_operator                                 = string,
      criteria_query                                    = string,
      criteria_threshold                                = number,
      criteria_time_aggregation_method                  = string,
      criteria_metric_measure_column                    = optional(string),
      criteria_resource_id_column                       = optional(string),
      criteria_minimum_failing_periods_to_trigger_alert = number,
      criteria_number_of_evaluation_periods             = number
    })
  }))

  description = <<EOT
    query_alert = {
      action_group_name: "The name of the action group."
      action_group_short_name: "The short name of the action group."
      action_group_email_receivers: "List of email recipients for the alert."
      
      rule_name: "The name of the scheduled query alert rule."
      rule_description: "The description of the scheduled query alert rule."
      rule_enabled: "Indicates whether the alert is enabled. Value should be true or false."
      rule_evaluation_frequency: "How often the alert rule is evaluated, represented in ISO 8601 duration format."
      rule_window_duration: "The period of time in ISO 8601 duration format on which the alert rule will be executed."
      rule_severity: "Severity of the alert, an integer between 0 and 4, with 0 being the most severe."
      rule_scopes: "A set of resource IDs that the alert rule is scoped to."
      rule_criteria_query: "The query to run on logs."
      rule_criteria_time_aggregation_method: "The type of aggregation to apply to the data points in aggregation granularity. Possible values are Average, Count, Maximum, Minimum, and Total."
      rule_criteria_threshold: "The criteria threshold value that activates the alert."
      rule_criteria_operator: "The criteria operator. Possible values are Equal, GreaterThan, GreaterThanOrEqual, LessThan, and LessThanOrEqual."
    }
  EOT
}

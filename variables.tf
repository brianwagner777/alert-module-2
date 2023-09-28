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
      email_receivers = list(object({ name = string, email_address = string }))
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

      criteria = object({
        operator                                 = string,
        query                                    = string,
        threshold                                = number,
        time_aggregation_method                  = string,
        metric_measure_column                    = optional(string),
        resource_id_column                       = optional(string),
        minimum_failing_periods_to_trigger_alert = optional(number, 1),
        number_of_evaluation_periods             = optional(number, 1)
      })
    })
  }))

  description = <<EOT
    query_alert = {
      action_group = {
        name: "The name of the action group."
        short_name: "The short name of the action group."
        email_receivers: "List of email recipients for the alert."
      }
      
      rule = {
        name: "The name of the scheduled query alert rule."
        description: "The description of the scheduled query alert rule."
        enabled: "Alert is enabled. Value should be true or false."
        evaluation_frequency: "How often the alert rule is evaluated, represented in ISO 8601 duration format."
        scopes: "A set of resource IDs that the alert rule is scoped to."
        severity: "Severity of the alert, an integer between 0 and 4, with 0 being the most severe."
        window_duration: "The period of time in ISO 8601 duration format on which the alert rule will be executed."
        auto_mitigation_enabled: "Indicates whether the alert should be automatically resolved or not."
        workspace_alerts_storage_enabled: "Indicates whether this scheduled query rule check if storage is configured."
        mute_actions_after_alert_duration: "Mute actions for the chosen period of time in ISO 8601 duration format after the alert is fired."
        query_time_range_override: "Set this if the alert evaluation period is different from the query time range."
        skip_query_validation: "Indicates whether the provided query should be validated or not."
        target_resource_types: "List of resource type of the target resource(s) on which the alert is created/updated."

        criteria = {
          operator: "The criteria operator. Possible values are Equal, GreaterThan, GreaterThanOrEqual, LessThan, and LessThanOrEqual."
          query: "The query to run on logs. The results returned by this query are used to populate the alert."
          threshold: "The criteria threshold value that activates the alert."
          time_aggregation_method: "The type of aggregation to apply to the data points in aggregation granularity. Possible values are Average, Count, Maximum, Minimum, and Total."
          metric_measure_column: "Specifies the column containing the metric measure number. Required if time_aggregation_method is Average, Minimum, Maximum, or Total."
          resource_id_column: "Specifies the column containing the resource ID. The content of the column must be an uri formatted as resource ID."
          minimum_failing_periods_to_trigger_alert: "Specifies the number of violations to trigger an alert. Should be smaller or equal to number_of_evaluation_periods. Possible value is integer between 1 and 6."
          number_of_evaluation_periods: "Specifies the number of aggregated look-back points. The look-back time window is calculated based on the aggregation granularity window_duration and the selected number of aggregated points. Possible value is integer between 1 and 6."
        }
      }
    }
  EOT
}

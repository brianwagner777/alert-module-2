variable "resource_group_name" {
  description = "Name of the resource group where the resources will be created."
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all created resources."
  default     = {}
}

variable "query_alerts" {
  type = list(object({ 
    action_group_name                      = string, 
    action_group_short_name                = string,
    action_group_email_receivers           = list(object({ name = string, email_address = string })),
    alert_name                             = string,
    alert_description                      = string,
    alert_enabled                          = bool,
    alert_evaluation_frequency             = string,
    alert_window_duration                  = string,
    alert_severity                         = number,
    alert_scope_resource_id                = string,
    alert_criteria_query                   = string,
    alert_criteria_time_aggregation_method = string,
    alert_criteria_threshold               = number,
    alert_criteria_operator                = string
  }))

  description = <<EOT
    query_alert = {
      action_group_name: "The name of the action group."
      action_group_short_name: "The short name of the action group."
      action_group_email_receivers: "List of email recipients for the alert."
      alert_name: "The name of the alert."
      alert_description: "The description of the alert rule."
      alert_enabled: "Indicates whether the alert is enabled. Value should be true or false."
      alert_evaluation_frequency: "How often the alert rule is evaluated, represented in ISO 8601 duration format."
      alert_window_duration: "The period of time in ISO 8601 duration format on which the alert rule will be executed."
      alert_severity: "Severity of the alert, an integer between 0 and 4, with 0 being the most severe."
      alert_scope_resource_id: "The resource ID that the alert rule is scoped to."
      alert_criteria_query: "The query to run on logs."
      alert_criteria_time_aggregation_method: "The type of aggregation to apply to the data points in aggregation granularity. Possible values are Average, Count, Maximum, Minimum, and Total."
      alert_criteria_threshold: "The criteria threshold value that activates the alert."
      alert_criteria_operator: "The criteria operator. Possible values are Equal, GreaterThan, GreaterThanOrEqual, LessThan, and LessThanOrEqual."
    }
  EOT
}

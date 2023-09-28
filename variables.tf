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
    action_group_name                     = string,
    action_group_short_name               = string,
    action_group_email_receivers          = list(object({ name = string, email_address = string })),
    
    rule_name                             = string,
    rule_description                      = string,
    rule_enabled                          = bool,
    rule_evaluation_frequency             = string,
    rule_window_duration                  = string,
    rule_severity                         = number,
    rule_scope_resource_ids               = set(string),
    rule_criteria_query                   = string,
    rule_criteria_time_aggregation_method = string,
    rule_criteria_threshold               = number,
    rule_criteria_operator                = string
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
      rule_scope_resource_id: "The resource ID that the alert rule is scoped to."
      rule_criteria_query: "The query to run on logs."
      rule_criteria_time_aggregation_method: "The type of aggregation to apply to the data points in aggregation granularity. Possible values are Average, Count, Maximum, Minimum, and Total."
      rule_criteria_threshold: "The criteria threshold value that activates the alert."
      rule_criteria_operator: "The criteria operator. Possible values are Equal, GreaterThan, GreaterThanOrEqual, LessThan, and LessThanOrEqual."
    }
  EOT
}

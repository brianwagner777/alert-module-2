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
      action_group_name: ""
      action_group_short_name: ""
      action_group_email_receivers: ""
      alert_name: ""
      alert_description: ""
      alert_enabled: ""
      alert_evaluation_frequency: ""
      alert_window_duration: ""
      alert_severity: ""
      alert_scope_resource_id: ""
      alert_criteria_query: ""
      alert_criteria_time_aggregation_method: ""
      alert_criteria_threshold: ""
      alert_criteria_operator: ""
    }
  EOT
}

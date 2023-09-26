variable "scheduled_query_alerts" {
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
    action_group_name: "The name of the action group."
    action_group_short_name: "The short name of the action group."
    action_group_email_receivers: "List of email recipients for the alert."
    alert_name: "The name of the alert."
  EOT
}

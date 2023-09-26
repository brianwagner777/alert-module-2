variable "resource_group_name" {
  description = "Name of the resource group where the resources will be created."
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all created resources."
  default     = {}
}

variable "scheduled_query_alerts" {
  type = list(object({ 
    action_group_name            = string, 
    action_group_short_name      = string,
    action_group_email_receivers = list(object({ name = string, email_address = string })),
    alert_name                   = string,
    alert_description            = string,
    alert_enabled                = bool
  }))
}

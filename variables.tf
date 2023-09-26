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
    action_group_name       = string, 
    action_group_short_name = string
  }))
}

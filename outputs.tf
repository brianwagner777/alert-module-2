output "query_alerts" {
  description = "Rules created for the query alerts."
  value       = azurerm_monitor_scheduled_query_rules_alert_v2.query_alert_rules
}

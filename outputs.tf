output "query_alerts" {
  description = "Logic app with all attributes."
  value       = azurerm_monitor_scheduled_query_rules_alert_v2.query_alert_rule
}

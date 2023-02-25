#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_notification_channel

resource "google_monitoring_notification_channel" "db-email-dl" {
  project      = var.project_id
  display_name = "Notification Email for DB"
  type         = "email"
  labels = {
    email_address = var.email_address
  }
}


resource "google_monitoring_alert_policy" "alert_policy_db_pod_up" {
  display_name = "db_pod_up"
  project      = var.project_id
  combiner     = "OR"
  documentation {
    content   = "Test Alert: One of the PostgreSQL pods is down for more 60s!"
    mime_type = "text/markdown"
  }
  conditions {
    display_name = "DB Pod Uptime"
    condition_threshold {
      filter                  = "metric.type=\"prometheus.googleapis.com/pg_up/gauge\" AND resource.type=\"prometheus_target\""
      duration                = "60s"
      comparison              = "COMPARISON_LT" # Triggers when Less Than
      threshold_value         = 1
      evaluation_missing_data = "EVALUATION_MISSING_DATA_ACTIVE"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MAX"
      }
    }
  }
  notification_channels = [
    google_monitoring_notification_channel.db-email-dl.id,
  ]

  user_labels = {
    component = "postgresql"
  }

  enabled = true
}

resource "google_monitoring_alert_policy" "alert_policy_db_max_transaction" {
  display_name = "db_max_transaction"
  project      = var.project_id
  combiner     = "OR"
  documentation {
    content   = "Test Alert: Max Lag of transaction (seconds) is above threshold!"
    mime_type = "text/markdown"
  }
  conditions {
    display_name = "Max Lag of transaction (seconds)"
    condition_threshold {
      filter                  = "metric.type=\"prometheus.googleapis.com/pg_stat_activity_max_tx_duration/gauge\" AND resource.type=\"prometheus_target\""
      duration                = "60s"
      comparison              = "COMPARISON_GT" # Triggers when Less Than
      threshold_value         = 10
      evaluation_missing_data = "EVALUATION_MISSING_DATA_INACTIVE"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
  notification_channels = [
    google_monitoring_notification_channel.db-email-dl.id,
  ]

  user_labels = {
    component = "postgresql"
  }

  enabled = true
}


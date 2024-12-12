resource "google_pubsub_topic" "cost_monitoring" {
  name = "${var.name}-pubsub-topic"
}

output "elasticsearch_endpoint" {
  value = ec_deployment.evaluation_trial.elasticsearch.https_endpoint
}

output "elasticsearch_username" {
  value = ec_deployment.evaluation_trial.elasticsearch_username
}

output "elasticsearch_password" {
  value = ec_deployment.evaluation_trial.elasticsearch_password
  sensitive = true
}
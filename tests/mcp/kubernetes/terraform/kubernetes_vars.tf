variable k8s_deployment_yml {
  description = "path to YAML file containing configuration for k8s_deployment"
  type        = map
  default = {
    "test_app_1" = "../resources/k8s_deployment.yml"
    "test_app_2" = "../resources/k8s_deployment_2.yml"
  }
}

variable k8s_service_yml {
  description = "path to YAML file containing configuration for k8s_service"
  type        = map
  default = {
    "test_app_1" = "../resources/k8s_service.yml"
  }
}

variable k8s_secret_files_yml {
  description = "path to YAML file containing configuration for k8s_secret_files"
  type        = map
  default = {
    "test_app_1" = "../resources/k8s_secret.yml"
  }
}

variable k8s_config_map_yml {
  description = "path to YAML file containing configuration for k8s_config_map"
  type        = map
  default = {
    "test_app_1" = "../resources/k8s_config_map.yml"
  }
}

variable k8s_pod_yml {
  description = "path to YAML file containing configuration for k8s_pod"
  type        = map
  default = {
    "test_app_1" = "../resources/k8s_pod.yml"
  }
}

variable k8s_ingress_yml {
  description = "path to YAML file containing configuration for k8s_ingress"
  type        = map
  default = {
    "test_app_1" = "../resources/k8s_ingress.yml"
  }
}

variable k8s_service_account_yml {
  description = "path to YAML file containing configuration for k8s_service_account"
  type        = map
  default = {
    "test_app_1" = "../resources/k8s_service_account.yml"
  }
}

variable k8s_job_yml {
  description = "path to YAML file containing configuration for k8s_job"
  type        = map
  default = {
    "test_app_1" = "../resources/k8s_job.yml"
  }
}

variable k8s_cron_job_yml {
  description = "path to YAML file containing configuration for k8s_cron_job"
  type        = map
  default = {
    "test_app_1" = "../resources/k8s_cron_job.yml"
  }
}

variable k8s_pod_autoscaler_yml {
  description = "path to YAML file containing configuration for k8s_pod_autoscaler"
  type        = map
  default = {
    "test_app_1" = "../resources/k8s_pod_autoscaler.yml"
  }
}

variable k8s_persistent_volume_yml {
  description = "path to YAML file containing configuration for k8s_persistent_volume"
  type        = map
  default = {
    "test_app_1" = "../resources/k8s_pod_persistent_volume.yml"
  }
}

variable k8s_persistent_volume_claim_yml {
  description = "path to YAML file containing configuration for k8s_persistent_volume_claim"
  type        = map
  default = {
    "test_app_1" = "../resources/k8s_pod_persistent_volume_claim.yml"
  }
}

variable "project_id" {
  description = "ID of the GCP project where the Cloud Run service is created."
  type        = string
}

variable "service_name" {
  description = "Name of the Cloud Run service."
  type        = string
}

variable "location" {
  description = "GCP region where the Cloud Run service is created."
  type        = string
}

variable "deletion_protection" {
  description = "Whether Terraform is prevented from deleting the Cloud Run service."
  type        = bool
  default     = false
}

variable "ingress" {
  description = "Controls which network traffic can reach the Cloud Run service."
  type        = string
  default     = "INGRESS_TRAFFIC_ALL"

  validation {
    condition = contains([
      "INGRESS_TRAFFIC_ALL",
      "INGRESS_TRAFFIC_INTERNAL_ONLY",
      "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER",
    ], var.ingress)
    error_message = "ingress must be INGRESS_TRAFFIC_ALL, INGRESS_TRAFFIC_INTERNAL_ONLY, or INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER."
  }
}

variable "labels" {
  description = "Labels to apply to the Cloud Run service."
  type        = map(string)
  default     = {}
}

variable "service_account" {
  description = "Email address of the service account used by Cloud Run revisions."
  type        = string
}

variable "min_instances" {
  description = "Minimum number of container instances kept available."
  type        = number
  default     = 0

  validation {
    condition     = var.min_instances >= 0
    error_message = "min_instances must be greater than or equal to 0."
  }
}

variable "max_instances" {
  description = "Maximum number of container instances allowed."
  type        = number
  default     = 10

  validation {
    condition     = var.max_instances >= 1
    error_message = "max_instances must be greater than or equal to 1."
  }
}

variable "image" {
  description = "Container image URI deployed by the Cloud Run service."
  type        = string
}

variable "container_port" {
  description = "Port on which the application container listens."
  type        = number
  default     = 8080

  validation {
    condition     = var.container_port >= 1 && var.container_port <= 65535
    error_message = "container_port must be between 1 and 65535."
  }
}

variable "cpu" {
  description = "CPU limit assigned to each container instance."
  type        = string
  default     = "1"
}

variable "memory" {
  description = "Memory limit assigned to each container instance, such as 512Mi or 1Gi."
  type        = string
  default     = "512Mi"
}

variable "environment_variables" {
  description = "Plain-text environment variables passed to the application container."
  type        = map(string)
  default     = {}
}

variable "invoker_members" {
  description = "Whether unathenticated users can invoke the cloud run app"
  type = set(string)
  default = []
  
}
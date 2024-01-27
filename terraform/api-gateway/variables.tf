variable "security_group_id" {
  type        = string
  description = "value of the security_group_id output from the security-group module"

}

variable "subnets_id" {
  type        = list(string)
  description = "value of the subnets_id output from the vpc module"
}

variable "service_discovery_service_a_arn" {
  type        = string
  description = "value of the private_dns_id output from the service-a module"
}

variable "service_discovery_service_b_arn" {
  type        = string
  description = "value of the private_dns_id output from the service-b module"
}


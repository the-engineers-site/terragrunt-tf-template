variable "env_full_name" {
  type     = string
  nullable = false
}

variable "vpc" {
  type = object({
    cidr     = string
    no_of_nats = number
  })
  nullable = false
}

variable "tags" {
  type     = map(string)
  nullable = false
}

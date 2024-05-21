variable "name" {
  description = "O nome do Resource Group"
  type        = string
}

variable "location" {
  description = "A localização do Resource Group"
  type        = string
}

variable "tags" {
  description = "Tags para o Resource Group"
  type        = map(string)
  default     = {}
}


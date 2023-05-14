variable "name" { type = string }
variable "name_prefix" { type = string }

variable "vpc_id" { type = string }
variable "inbound_ports" { type = list(string) }
variable "inbound_cidr_blocks" {
  type = list(string)
  default = null
}
variable "inbound_source_security_group_id" {
  type = string
  default = null
}
variable "application_name" {
  type = string
}
variable "environment_name" {
  type = string
}
variable "primary_location" {
  type = string
}
variable "environment_full_name" {
  type = string
}
variable "secret_names" {
  type = set(string)
}

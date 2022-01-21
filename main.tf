variable "access_key" {
  type = "string"
  default = "XXXXX"
}
variable "secret_key" {
  type = "string"
  default = "XXXXX"
}
variable "region" {
  type = "string"
  default = "Singapore Zone B"
}
variable "vswitch" {
  type = "string"
  default = "vsw-t4nk6aeunlxyn07tzvf8n"
}
variable "sgroups" {
  type = "list"
  default = [
    "sg-wp"
  ]
}
variable "name" {
  type = "string"
  default = "WP-instance"
}
variable "password" {
  type = "string"
  default = "Test1234!"
}
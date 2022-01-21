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
provider "alicloud" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

data "alicloud_images" "search" {
  name_regex = "^ubuntu_16.*_64"
}
data "alicloud_instance_types" "default" {
  instance_type_family = "ecs.xn4"
  cpu_core_count = 1
  memory_size = 1
}
resource "alicloud_instance" "web" {
  instance_name = "${var.name}"
  image_id = "${data.alicloud_images.search.images.0.image_id}"
  instance_type = "${data.alicloud_instance_types.default.instance_types.0.id}"

  vswitch_id = "${var.vswitch}"
  security_groups = "${var.sgroups}"
  internet_max_bandwidth_out = 100
  allocate_public_ip = true

  password = "${var.password}"

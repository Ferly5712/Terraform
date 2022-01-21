provider "alicloud" {
  access_key = "XXXXX"
  secret_key = "XXXXX"
  region     = "ap-southeast-1"
}

data "alicloud_instances" "instances_ds" {
  name_regex = "wp-instance"
  status     = "Running"
}
resource "alicloud_image" "gold-image" {
  instance_id  = "${data.alicloud_instances.instances_ds.instances.0.id}"
  image_name   = "gold-image"
  description  = "gold-image"
  architecture = "x86_64"
  platform     = "Ubuntu"
}

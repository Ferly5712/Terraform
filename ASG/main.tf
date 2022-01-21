provider "alicloud" {
  access_key = "XXXXXX"
  secret_key = "XXXXXX"
  region     = "ap-southeast-1"
}
variable "vswitch" {
  type    = string
  default = "vsw-t4nk6aeunlxyn07tzvf8n"
}
data "alicloud_images" "default" {
  name_regex  = "gold-image"
  most_recent = true
  owners      = "system"
}
 
resource "alicloud_ess_scaling_group" "asg_wp" {
  min_size           = 1
  max_size           = 2
  scaling_group_name = "asg_wp"
  vswitch_id         = var.vswitch
  removal_policies   = ["OldestInstance", "NewestInstance"]
}
 
resource "alicloud_ess_scaling_configuration" "default" {
  scaling_group_id  = alicloud_ess_scaling_group.asg_wp.id
  image_id          = data.alicloud_images.default.images[0].id
  instance_type     = "ecs.xn4"
  security_group_id = "sf-wp"
  force_delete      = "true"
}
 
resource "alicloud_ess_scaling_rule" "default" {
  scaling_group_id = alicloud_ess_scaling_group.asg_wp.id
  adjustment_type  = "TotalCapacity"
  adjustment_value = 1
}

variable "access_key" {
  type    = string
  default = "XXXX"
}
variable "secret_key" {
  type    = string
  default = "XXXX"
}
variable "region" {
  type    = string
  default = "ap-southeast-1"
}
variable "vswitch" {
  type    = string
  default = "vsw-t4nk6aeunlxyn07tzvf8n"
}
variable "sgroups" {
  type = list(any)
  default = [
    "sg-t4n2zp3wr6kknn8pde1s"
  ]
}
variable "name" {
  type    = string
  default = "wp-instance"
}
variable "password" {
  type    = string
  default = "Test1234!"
}
provider "alicloud" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

data "alicloud_images" "search" {
  name_regex = "^ubuntu_16.*_64"
}
data "alicloud_instance_types" "default" {
  instance_type_family = "ecs.xn4"
  cpu_core_count       = 1
  memory_size          = 1
}

 
resource "alicloud_security_group_rule" "block_ssh_telnet" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "internet"
  policy            = "drop"
  port_range        = "22/23"
  priority          = 1
  security_group_id = "sg-t4n2zp3wr6kknn8pde1s"
  cidr_ip           = "0.0.0.0/0"
}
resource "alicloud_instance" "web" {
  instance_name = var.name
  image_id      = "ubuntu_16_04_x64_20G_alibase_20211028.vhd"
  instance_type = data.alicloud_instance_types.default.instance_types.0.id

  vswitch_id                 = var.vswitch
  security_groups            = var.sgroups
  internet_max_bandwidth_out = 100
  ##allocate_public_ip = true

  password = var.password

  provisioner "remote-exec" {
    inline = [
      "timedatectl set-timezone Asia/Jakarta",
      "apt-get update && apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -",
      "add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "apt-get update && apt-get install -y docker-ce docker-compose",
      "curl https://raw.githubusercontent.com/Ferly5712/WPBro/main/docker-compose.yml -o docker-compose.yml",
      "curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/bin/docker-compose",
      "docker-compose up -d"
    ]

    connection {
      host     = alicloud_instance.web.public_ip
      password = var.password
    }
  }
}
output "ip" {
  value = alicloud_instance.web.public_ip
}


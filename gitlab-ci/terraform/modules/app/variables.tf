variable public_key_path {
  description = "Path to the public key used to connect to instance"
}
variable zone {
  description = "Zone"
}
variable app_disk_image {
  description = "Disk image for reddit app"
}
variable "db_address" {
  description = "address of db"
}

variable "network" {}
variable "app_ip" {}

variable "private_key" {}
variable "autodeploy" {
}

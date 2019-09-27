terraform {
  # Версия terraform
  required_version = ">0.11,<0.12"

}

provider "google" {
  # Версия провайдера
  version = "2.0.0"

  # ID проекта
  project = "${var.project}"
  region  = "${var.region}"
}

module "core" {
  source = "modules/app"
  public_key_path = "${var.public_key_path}"
  zone = "${var.zone}"
  app_disk_image = "${var.disk_image}"
  network="${module.vpc.my_net}"
  private_key = "${file(var.private_key_path)}"
  tag = "gitlab-core"
  machine_type = "n1-standard-1"
}

module "dev-stage" {
  source = "modules/app"
  public_key_path = "${var.public_key_path}"
  zone = "${var.zone}"
  app_disk_image = "${var.disk_image}"
  network="${module.vpc.my_net}"
  private_key = "${file(var.private_key_path)}"
  tag = "dev-stage"
  machine_type = "g1-small"
}

module "runners" {
  source = "modules/app"
  count = 3
  public_key_path = "${var.public_key_path}"
  zone = "${var.zone}"
  app_disk_image = "${var.disk_image}"
  network="${module.vpc.my_net}"
  private_key = "${file(var.private_key_path)}"
  tag = "runner"
  machine_type = "g1-small"
}

module "vpc" {
  source = "modules/vpc"
  tags = ["gitlab-core", "dev-stage", "runner"]
}

resource "template_file" "runner" {
  template = "${file("templates/runner.tpl")}"
  count = "${module.runners.count}"
  vars {
    name = "runner-${count.index}"
    runners_ext_ip = "${module.runners.app_external_ip[count.index]}"
  }
}

resource "template_file" "yml_inv" {
  template = "${file("templates/inventory.yml.tpl")}"
  vars {
    core_ext_ip = "${module.core.app_external_ip[0]}"
    dev_ext_ip = "${module.dev-stage.app_external_ip[0]}"
    runners_hosts = "${join("", template_file.runner.*.rendered)}"
  }
}

resource "local_file" "yml_inv" {
  filename = "../ansible/inventory.yml"
  content = "${template_file.yml_inv.rendered}"
}

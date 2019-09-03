terraform {
  # Версия terraform
  required_version = ">0.11,<0.12"
  backend "gcs" {
    bucket  = "storage-bucket-stage"
    prefix  = "terraform/state"
  }
}

provider "google" {
  # Версия провайдера
  version = "2.0.0"

  # ID проекта
  project = "${var.project}"
  region  = "${var.region}"
}

module "app" {
  source = "../modules/app"
  public_key_path = "${var.public_key_path}"
  zone = "${var.zone}"
  app_disk_image = "${var.app_disk_image}"
  db_address = "${module.vpc.db_ip}"
  network="${module.vpc.my_net}"
  private_key = "${file(var.private_key_path)}"
  autodeploy = "${var.autodeploy}"
  app_ip = "${module.vpc.app_ip}"
}

module "db" {
  source = "../modules/db"
  public_key_path = "${var.public_key_path}"
  zone = "${var.zone}"
  db_disk_image = "${var.db_disk_image}"
  network="${module.vpc.my_net}"
  private_key = "${file(var.private_key_path)}"
  db_ip = "${module.vpc.db_ip}"
}

module "vpc" {
  source = "../modules/vpc"
  source_ranges = ["0.0.0.0/0"]
  app_ip = "${module.app.app_internal_ip}"
  region        = "${var.region}"

}

resource "template_file" "dyn_inv" {
  template = "${file("templates/dynamic_inventory.json")}"
  vars {
    app_ext_ip = "${module.app.app_external_ip[0]}"
    db_ext_ip = "${module.db.db_external_ip[0]}"
    db_int_ip = "${module.vpc.db_ip}"
  }
}

resource "template_file" "yml_inv" {
  template = "${file("templates/inventory.yml.tpl")}"
  vars {
    app_ext_ip = "${module.app.app_external_ip[0]}"
    db_ext_ip = "${module.db.db_external_ip[0]}"
    db_int_ip = "${module.vpc.db_ip}"
  }
}

resource "local_file" "yml_inv" {
  filename = "../../ansible/environments/stage/inventory.yml"
  content = "${template_file.yml_inv.rendered}"
}

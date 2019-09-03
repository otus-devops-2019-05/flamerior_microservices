resource "google_compute_instance" "app" {
  name = "reddit-app"
  machine_type = "g1-small"
  zone = "${var.zone}"
  tags = ["reddit-app"]
  boot_disk {
    initialize_params { image = "${var.app_disk_image}" }
  }
  network_interface {
    network = "${var.network}"
    network_ip = "${var.app_ip}"
    access_config = {
    }
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

}

locals {
  autodeploy="sh ./deploy.sh"
  info="echo 'to deploy run \n sh deploy.sh' >> ~/README"
}

resource "template_file" "puma_service" {
  template = "${file("${path.module}/files/puma.tpl")}"
  vars = {
    db_ip="${var.db_address}"
  }

}

resource "google_compute_instance" "app" {
  name = "gitlab-core"
  machine_type = "${var.machine_type}"
  zone = "${var.zone}"
  tags = ["${var.tag}"]
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

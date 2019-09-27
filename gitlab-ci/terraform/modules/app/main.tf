resource "google_compute_instance" "app" {
  name = "${var.tag}-${count.index}"
  machine_type = "${var.machine_type}"
  zone = "${var.zone}"
  tags = ["${var.tag}"]
  count = "${var.count}"
  boot_disk {
    initialize_params { image = "${var.app_disk_image}" }
  }
  network_interface {
    network = "${var.network}"
    access_config = {
    }
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

}

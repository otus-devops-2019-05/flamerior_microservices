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

resource "google_compute_instance" "with-docker" {
  name = "reddit-wd-${count.index}"
  machine_type = "g1-small"
  count = "${var.with_docker_count}"
  zone = "${var.zone}"
  tags = ["reddit-docker"]
  boot_disk {
    initialize_params { image = "reddit-app-docker-base" }
  }
  network_interface {
    network = "default"
    access_config = {
    }
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

}


resource "google_compute_instance" "without-docker" {
  name = "reddit-wod-${count.index}"
  machine_type = "g1-small"
  count = "${var.without_docker_count}"
  zone = "${var.zone}"
  tags = ["reddit-docker"]
  boot_disk {
    initialize_params { image = "ubuntu-1604-lts" }
  }
  network_interface {
    network = "default"
    access_config = {
    }
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

}

resource "google_compute_firewall" "firewall_ssh" {
  name = "allow-ssh-and-app"
  network = "default"
  target_tags = ["reddit-docker"]
  allow {
    protocol = "tcp"
    ports = ["22", "9292", "80"]
  }
  source_ranges = ["0.0.0.0/0"]

}

data "template_file" "wd" {
  template = "${file("host.json")}"
  count = "${google_compute_instance.with-docker.count}"
  vars {
    ip = "${element(google_compute_instance.with-docker.*.network_interface.0.access_config.0.nat_ip, count.index)}"
    name = "${element(google_compute_instance.with-docker.*.name, count.index)}"
  }
}

data "template_file" "wod" {
  template = "${file("host.json")}"
  count = "${google_compute_instance.without-docker.count}"
  vars {
    ip = "${element(google_compute_instance.without-docker.*.network_interface.0.access_config.0.nat_ip, count.index)}"
    name = "${element(google_compute_instance.without-docker.*.name, count.index)}"
  }
}

resource "template_file" "dyn_inv" {
  template = "${file("dynamic_inventory.json")}"
  vars {
    all_hosts = "${join(",", concat(data.template_file.wd.*.rendered, data.template_file.wod.*.rendered))}"
    docker_host_names = "${jsonencode(google_compute_instance.with-docker.*.name)}"
    empty_hosts_names = "${jsonencode(google_compute_instance.without-docker.*.name)}"
  }
}

resource "google_compute_network" "internal_net" {
  name          = "my-net"
}
resource "google_compute_firewall" "firewall_ssh" {
  name = "default-allow-ssh"
  network = "${google_compute_network.internal_net.self_link}"
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  source_ranges = "${var.source_ranges}"
}
resource "google_compute_firewall" "firewall_db" {
  name = "allow-db-default"
  network = "${google_compute_network.internal_net.self_link}"
  allow {
    protocol = "tcp", ports = ["27017", "22"]
  }
  source_ranges = ["${var.app_ip}/32"]
  target_tags = ["reddit-db"]
  source_tags = ["reddit-app"]
}

resource "google_compute_address" "app_ip" {
  subnetwork   = "${google_compute_network.internal_net.self_link}"
  address_type = "INTERNAL"
  region       = "${var.region}"
  name = "reddit-app-ip" }

resource "google_compute_global_address" "app_global" {
  name = "app-global"
}
resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  network = "${google_compute_network.internal_net.self_link}"
  allow {
    protocol = "tcp", ports = ["9292", "80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["reddit-app"]
}


resource "google_compute_address" "db-address" {
  name         = "db-internal-address"
  subnetwork   = "${google_compute_network.internal_net.self_link}"
  address_type = "INTERNAL"
  region       = "${var.region}"
}

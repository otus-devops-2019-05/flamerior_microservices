resource "google_compute_network" "internal_net" {
  name          = "my-net"
}
resource "google_compute_firewall" "firewall_ssh" {
  name = "allow-ssh-gitlab-core"
  network = "${google_compute_network.internal_net.self_link}"
  allow {
    protocol = "tcp"
    ports = ["22", "80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["gitlab-core"]

}
resource "google_compute_address" "app_ip" {
  subnetwork   = "${google_compute_network.internal_net.self_link}"
  address_type = "INTERNAL"
  region       = "${var.region}"
  name = "reddit-app-ip" }


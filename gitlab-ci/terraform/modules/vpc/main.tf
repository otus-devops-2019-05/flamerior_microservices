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
  target_tags = "${var.tags}"

}


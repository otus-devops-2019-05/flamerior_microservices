output "my_net" {
  value = "${google_compute_network.internal_net.self_link}"
}

output "app_ip" {
  value = "${google_compute_address.app_ip.address}"
}

output "db_ip" {
  value = "${google_compute_address.db-address.address}"
}

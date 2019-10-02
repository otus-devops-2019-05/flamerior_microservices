output "my_net" {
  value = "${google_compute_network.internal_net.self_link}"
}


resource "google_container_cluster" "reddit_cluster" {
  name     = "reddit-cluster"
  location   = "us-central1-b"
  remove_default_node_pool = true
  initial_node_count       = 1

  addons_config {
    network_policy_config {
      disabled = true
    }
  }

  master_auth {
    username = "${var.username}"
    password = "${var.password}"

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "bigpool" {
  name       = "my-bigpool-pool"
  location   = "us-central1-b"
  cluster    = "${google_container_cluster.reddit_cluster.name}"
  node_count = 2

  node_config {
    preemptible  = true
    machine_type = "n1-standard-2"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
resource "google_container_node_pool" "smallpool" {
  name       = "my-smallpool-pool"
  location   = "us-central1-b"
  cluster    = "${google_container_cluster.reddit_cluster.name}"
  node_count = 2

  node_config {
    preemptible  = true
    machine_type = "g1-small"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
resource "google_compute_firewall" "k8s_firewall" {
  name    = "allow-k8s-ui"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }

  source_ranges = ["0.0.0.0/0"]
}


resource "google_compute_network" "gke_network" {
  name                    = "${var.network_name}"
  description             = "VPC That hosts the GKE Cluster"
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "europe" {
  count                    = 3
  name                     = "europe${count.index + 1}"
  ip_cidr_range            = "${cidrsubnet(var.cidr_block, 8, count.index + 1)}"
  region                   = "europe-west${count.index + 1}"
  network                  = "${google_compute_network.gke_network.self_link}"
  private_ip_google_access = true
  enable_flow_logs         = true
}

resource "google_compute_firewall" "gke_network" {
  name    = "gke-wordpress"
  network = "${google_compute_network.gke_network.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_ranges = ["0.0.0.0/0"]
}

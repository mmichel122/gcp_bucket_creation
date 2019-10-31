output "network_vpc_uri" {
  value = "${google_compute_network.gke_network.self_link}"
}

output "subnetwork_link" {
  value = "${google_compute_subnetwork.europe.1.name}"
}

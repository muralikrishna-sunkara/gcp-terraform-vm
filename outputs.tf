output "vpc_name" {
  description = "Name of the VPC"
  value       = google_compute_network.vpc.name
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = google_compute_network.vpc.id
}

output "subnet_1_name" {
  description = "Name of subnet 1"
  value       = google_compute_subnetwork.subnet_1.name
}

output "subnet_1_cidr" {
  description = "CIDR block of subnet 1"
  value       = google_compute_subnetwork.subnet_1.ip_cidr_range
}

output "subnet_2_name" {
  description = "Name of subnet 2"
  value       = google_compute_subnetwork.subnet_2.name
}

output "subnet_2_cidr" {
  description = "CIDR block of subnet 2"
  value       = google_compute_subnetwork.subnet_2.ip_cidr_range
}

output "vm_name" {
  description = "Name of the VM instance"
  value       = google_compute_instance.web_server.name
}

output "vm_internal_ip" {
  description = "Internal IP address of the VM"
  value       = google_compute_instance.web_server.network_interface[0].network_ip
}

output "vm_external_ip" {
  description = "External IP address of the VM"
  value       = google_compute_instance.web_server.network_interface[0].access_config[0].nat_ip
}

output "web_url" {
  description = "URL to access the DevOps web page"
  value       = "http://${google_compute_instance.web_server.network_interface[0].access_config[0].nat_ip}"
}

output "ssh_command" {
  description = "SSH command to connect to the VM"
  value       = "gcloud compute ssh ${google_compute_instance.web_server.name} --zone=${var.zone}"
}

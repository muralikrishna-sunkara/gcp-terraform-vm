terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Create VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project_name}-vpc"
  auto_create_subnetworks = false
  description             = "Custom VPC for DevOps demo"
}

# Create Subnet 1
resource "google_compute_subnetwork" "subnet_1" {
  name          = "${var.project_name}-subnet-1"
  ip_cidr_range = var.subnet_1_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  description   = "First subnet in eu-central region"
}

# Create Subnet 2
resource "google_compute_subnetwork" "subnet_2" {
  name          = "${var.project_name}-subnet-2"
  ip_cidr_range = var.subnet_2_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  description   = "Second subnet in eu-central region"
}

# Firewall rule to allow HTTP traffic
resource "google_compute_firewall" "allow_http" {
  name    = "${var.project_name}-allow-http"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
  description   = "Allow HTTP traffic from anywhere"
}

# Firewall rule to allow SSH traffic
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.project_name}-allow-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-server"]
  description   = "Allow SSH traffic from anywhere"
}

# Create Ubuntu VM with nginx
resource "google_compute_instance" "web_server" {
  name         = "${var.project_name}-web-server"
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["http-server", "ssh-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet_1.id

    access_config {
      # Ephemeral public IP
    }
  }

  metadata = {
    ssh-keys = var.ssh_public_key != "" ? "${var.ssh_user}:${var.ssh_public_key}" : ""
  }

  metadata_startup_script = file("${path.module}/startup-script.sh")

  service_account {
    scopes = ["cloud-platform"]
  }

  allow_stopping_for_update = true

  labels = {
    environment = "demo"
    purpose     = "devops-web-server"
  }
}

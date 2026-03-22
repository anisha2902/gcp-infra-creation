resource "google_project" "project" {
  project_id      = var.project_id
  name            = var.project_name
  org_id          = var.org_id
  billing_account = var.billing_account
}

resource "google_project_service" "compute" {
  project = google_project.project.project_id
  service = "compute.googleapis.com"
}

resource "google_compute_network" "vpc" {
  name                    = "app-vpc"
  auto_create_subnetworks = false
  depends_on              = [google_project_service.compute]
}

resource "google_compute_subnetwork" "subnet" {
  name          = "app-subnet"
  region        = var.region
  ip_cidr_range = "10.10.0.0/24"
  network       = google_compute_network.vpc.id
}

resource "google_compute_firewall" "allow_ssh_app" {
  name    = "allow-ssh-app"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", tostring(var.app_port)]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["app-server"]
}

resource "google_compute_address" "public_ip" {
  name   = "vm-public-ip"
  region = var.region
}

resource "google_compute_instance" "vm" {
  name         = "ubuntu-vm"
  machine_type = "e2-medium"
  zone         = var.zone
  tags         = ["app-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {
      nat_ip = google_compute_address.public_ip.address
    }
  }

  metadata = {
    enable-oslogin = "TRUE"
  }
}

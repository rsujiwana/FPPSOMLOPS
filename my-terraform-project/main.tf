provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_compute_instance" "existing_instance" {
  name    = "fppsomlops-instance"
  zone    = var.default_zone
  project = var.project_id
}

resource "google_compute_instance" "vm_instance" {
  name         = "fppsomlops-instance"
  machine_type = var.instance_type
  zone         = var.default_zone

  count = length(data.google_compute_instance.existing_instance) == 0 ? 1 : 0

  boot_disk {
    initialize_params {
      image = var.image
      size  = 50
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {}
  }

  metadata_startup_script = file("startup-script.sh")

  service_account {
    email  = var.service_account_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = ["http-server", "https-server"]
}

output "instance_ip" {
  value = google_compute_instance.vm_instance[0].network_interface[0].access_config[0].nat_ip
}

data "google_compute_firewall" "existing_firewall" {
  name    = "allow-http-https-ssh"
  project = var.project_id
}

resource "google_compute_firewall" "default" {
  name    = "allow-http-https-ssh"
  network = google_compute_network.vpc_network.name

  count = length(data.google_compute_firewall.existing_firewall) == 0 ? 1 : 0

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

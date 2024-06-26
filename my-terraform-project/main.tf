provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "vpc_network" {
  name = "fppsomlops-network"
}

resource "google_compute_instance" "vm_instance" {
  name         = "fppsomlops-instance"
  machine_type = var.instance_type
  zone         = var.default_zone

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
   lifecycle {
    prevent_destroy = true
    ignore_changes  = [metadata_startup_script]  # Example of ignoring changes
  }
}

output "instance_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

resource "google_compute_firewall" "default" {
  name    = "allow-http-https-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

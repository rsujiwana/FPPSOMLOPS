provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project_id
  region      = var.region
}

resource "google_compute_network" "vpc_network" {
  name = var.network_name
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = var.instance_type
  zone         = var.default_zone

  boot_disk {
    initialize_params {
      image = var.image
      size = 50 // Ukuran disk dalam gigabyte
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {}
  }

  metadata_startup_script = <<-EOF
  #!/bin/bash
  sudo apt-get update -y
  sudo apt-get install -y docker.io
  sudo systemctl start docker
  sudo usermod -aG docker ${var.gcp_user}
  sudo docker pull kurniarafi44078/fppsomlops:v0.1
  sudo curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
  sudo chmod 755 /usr/local/bin/docker-compose
EOF


  service_account {
    email  = var.service_account_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = ["http-server", "https-server"]
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

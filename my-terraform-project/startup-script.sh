#!/bin/bash
# Perintah lainnya...
echo "Startup script running..." > /var/log/startup-script.log
sudo apt-get update -y
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo usermod -aG docker tsaniyah_coshack1019
sudo docker pull kurniarafi44078/fppsomlops:v0.1
sudo docker run -d -p 80:5000 kurniarafi44078/fppsomlops:v0.1
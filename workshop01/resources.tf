data "digitalocean_ssh_key" "DO_public_key_name" {
  name = var.DO_public_key_name # using fred
}

########## Resources ##########

# nginx server
resource "digitalocean_droplet" "nginx" {
    name = "nginx"
    image = var.droplet_image
    size = var.droplet_size
    region = var.droplet_region
    ssh_keys = [
        data.digitalocean_ssh_key.DO_public_key_name.id
    ]

    connection {
      type = "ssh"
      private_key = file(var.private_key_filepath)
      user = "root"
      host = self.ipv4_address
    }

    # installs nginx
    provisioner "remote-exec" {
      inline = [ 
        "apt update -y", 
        "apt upgrade -y",
        "apt install -y nginx",
        "systemctl start nginx",
        "systemctl enable nginx"
      ]
    }
    # copys contents of `assets` directory into `/var/www/html`
    provisioner "file" {
      source = "./assets/"
      destination = "/var/www/html"
    }

    provisioner "remote-exec" {
      inline = [ 
        "sed -i 's/Droplet IP address here/${self.ipv4_address}/g' /var/www/html/index.html"
      ]
    }
}

resource "local_file" "file" {
    filename = "nginx-${digitalocean_droplet.nginx.ipv4_address}.nip.io"
    content = ""
}

output "nginx_ipv4" {
  value = digitalocean_droplet.nginx.ipv4_address
}
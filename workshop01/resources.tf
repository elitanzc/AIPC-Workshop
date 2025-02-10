data "digitalocean_ssh_key" "DO_public_key_name" {
  name = var.DO_public_key_name # using fred
}

# # can create ssh-keygen -t ed25519 -f /opt/tmp/workshop01_ed25519
# resource "digitalocean_ssh_key" "workshop01_pub" {
#   name = "workshop01_pub"
#   public_key = file("/opt/tmp/workshop01_ed25519.pub") # can store as filepath to pubkey var
# }

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

# # this doesn't work, will be done only after nginx server has been created, else there'll be cyclic
# resource "local_file" "index_html" {
#   filename = "assets/index.html"
#   file_permission = "0644"
#   content = templatefile("assets/index.html.tftpl", {
#     droplet_ip = digitalocean_droplet.nginx.ipv4_address
#   })
# }

resource "local_file" "file" {
    filename = "nginx-${digitalocean_droplet.nginx.ipv4_address}.nip.io"
    content = ""
    file_permission = "0444"
}

output "nginx_ipv4" {
  value = digitalocean_droplet.nginx.ipv4_address
}
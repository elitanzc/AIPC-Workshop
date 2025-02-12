data "digitalocean_ssh_key" "DO_public_key_name" {
  name = var.DO_public_key_name # using fred
}

# # can create ssh-keygen -t ed25519 -f /opt/tmp/workshop01_ed25519
# resource "digitalocean_ssh_key" "workshop01_pub" {
#   name = "workshop01_pub"
#   public_key = file("/opt/tmp/workshop01_ed25519.pub") # can store as filepath to pubkey var
# }

data "digitalocean_image" "workshop03_snapshot" {
  name = "workshop03-snapshot" # the name of the snapshot created in ../build
}

########## Resources ##########

# Ubuntu server
resource "digitalocean_droplet" "server" {
    name = "workshop03-server"
    image = data.digitalocean_image.workshop03_snapshot.id
    size = var.server_specs.size
    region = var.server_specs.region
    ssh_keys = [
        data.digitalocean_ssh_key.DO_public_key_name.id
    ]

    connection {
      type = "ssh"
      private_key = file(var.private_key_filepath)
      user = "root"
      host = self.ipv4_address
    }

    # customize golden image with own code server password and domain during provisioning
    provisioner "remote-exec" {
      inline = [ 
        "sed -i 's/__CODE_SERVER_PASSWORD__/${var.code_server_password}/g' /lib/systemd/system/code-server.service",
        "sed -i 's/__CODE_SERVER_DOMAIN__/code-${self.ipv4_address}.nip.io/g' /etc/nginx/sites-available/code-server.conf",
        "systemctl daemon-reload",
        "systemctl restart code-server",
        "systemctl restart nginx"
      ]
    }
}

resource "local_file" "file" {
    filename = "root@${digitalocean_droplet.server.ipv4_address}"
    content = ""
    file_permission = "0444"
}

output "server_ipv4" {
  value = digitalocean_droplet.server.ipv4_address
}
output "code_server_domain" {
  value = "code-${digitalocean_droplet.server.ipv4_address}.nip.io"
}
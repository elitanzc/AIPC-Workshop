data "digitalocean_ssh_key" "DO_public_key_name" {
  name = var.DO_public_key_name # using fred
}

# # can create ssh-keygen -t ed25519 -f /opt/tmp/workshop01_ed25519
# resource "digitalocean_ssh_key" "workshop01_pub" {
#   name = "workshop01_pub"
#   public_key = file("/opt/tmp/workshop01_ed25519.pub") # can store as filepath to pubkey var
# }

########## Resources ##########

# Ubuntu server
resource "digitalocean_droplet" "server" {
    name = "workshop02-server"
    image = var.droplet_image
    size = var.droplet_size
    region = var.droplet_region
    ssh_keys = [
        data.digitalocean_ssh_key.DO_public_key_name.id
    ]
}

resource "local_file" "file" {
    filename = "root@${digitalocean_droplet.server.ipv4_address}"
    content = ""
    file_permission = "0444"
}

# generate inventory.yaml with vars found here
resource "local_file" "inventories_yaml" {
    filename = "../inventory.yaml"
    content = templatefile("../inventory.yaml.tftpl", {
      private_key_filepath = var.private_key_filepath
      droplet_ip = digitalocean_droplet.server.ipv4_address
      code_server_password = var.code_server_password
    })
    file_permission = "0444"
}

output "server_ipv4" {
  value = digitalocean_droplet.server.ipv4_address
}
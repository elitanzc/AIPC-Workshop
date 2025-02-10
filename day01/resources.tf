data "digitalocean_ssh_key" "work1" {
  name = var.DO_public_key_name
}

# output "work1_fingerprint" {
#     description = "Fingerprint of ssh public key"
#     value = data.digitalocean_ssh_key.work1.fingerprint
# }

# output "work1_pubkey" {
#     value = data.digitalocean_ssh_key.work1.public_key
# }


# ########## Example: create single droplet ##########
# resource "digitalocean_droplet" "droplet-day01" {
#     name = "droplet-day01"
#     image = var.droplet_image
#     size = var.droplet_size
#     region = var.droplet_region
#     ssh_keys = [
#         data.digitalocean_ssh_key.work1.id
#     ]
# }
# # `tf apply`, then `tf output` to see value
# output "droplet-day01-ipv4" {
#     description = "Droplet public IP address"
#     value = digitalocean_droplet.droplet-day01.ipv4_address
# }


########## Example: create multiple from count param ##########
resource "digitalocean_droplet" "droplet-day01-count" {
    count = var.instance_count
    name = "droplet-day01-${count.index}"
    image = var.droplet_image
    size = var.droplet_size
    region = var.droplet_region
    ssh_keys = [
        data.digitalocean_ssh_key.work1.id
    ]

    connection {
      type = "ssh"
      private_key = file(var.private_key_filepath)
      user = "root"
      host = self.ipv4_address
    }

    provisioner "remote-exec" {
      inline = [ "apt update", "apt upgrade -y" ]
    }
}
output "droplet-day01-ipv4-all" {
    value = join(",", digitalocean_droplet.droplet-day01-count[*].ipv4_address) # outputs a csv value
    # value = digitalocean_droplet.droplet-day01-count[*].ipv4_address # outputs a list
}

### generate file example
# This writes all ip addresses into a file
# Step 1. create a template file droplets_ips.txt.tftpl (the blueprint)
# ```
# List of droplet IPs
# 
# %{ for ip in droplet_ips }
# - ${ip}}
# %{ endfor }
# ```
# Step 2:
resource "local_file" "droplets_ips_txt" {
    filename = "droplets_ips.txt"
    content = templatefile(
        "droplets_ips.txt.tftpl", 
        {
            message = "Generated on Feb 10 2025"
            droplet_ips = digitalocean_droplet.droplet-day01-count[*].ipv4_address
            # droplet_ips = [ for droplet in digitalocean_droplet.droplet-day01-count: droplet.ipv4_address ]
        }
    )
}


# ########## Example: create multiple from for_each loop ##########
# resource "digitalocean_droplet" "droplet-day01-foreach" {
#     for_each = var.servers
#     name = each.key # myserver-512mb / myserver-1gb
#     image = each.value.image
#     size = each.value.size
#     region = var.droplet_region
#     ssh_keys = [
#         data.digitalocean_ssh_key.work1.id
#     ]
# }
# output "droplet-day01-ipv4-all-foreach" {
#     # cannot use [*] for maps
#     value = join(",", [
#         for droplet in  digitalocean_droplet.droplet-day01-foreach: droplet.ipv4_address
#     ])
# }
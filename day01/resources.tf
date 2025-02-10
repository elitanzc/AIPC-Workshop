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

resource "digitalocean_droplet" "droplet-day01" {
    count = var.instance_count
    name = "droplet-day01-${count.index}"
    image = var.droplet_image
    size = var.droplet_size
    region = var.droplet_region
    ssh_keys = [
        data.digitalocean_ssh_key.work1.id
    ]
}

# # `tf apply`, then `tf output` to see value
# output "droplet-day01-ipv4" {
#     description = "Droplet public IP address"
#     value = digitalocean_droplet.droplet-day01.ipv4_address
# }

output "droplet-day01-ipv4-all" {
    value = join(",", digitalocean_droplet.droplet-day01[*].ipv4_address) # outputs a csv value
    # value = digitalocean_droplet.droplet-day01[*].ipv4_address # outputs a list
}
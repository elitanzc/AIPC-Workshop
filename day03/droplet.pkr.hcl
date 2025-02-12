# the top-level source block defines reusable builder configuration blocks
source "digitalocean" "mydroplet" {
    api_token = var.DO_token
    ssh_username = "root"
}

build {
    # can set specific source fields like this, 
    # but each field can only be defined once -- either here or at the top-level source block
    source "digitalocean.mydroplet" {
        snapshot_name = "mydroplet"
        size = var.server_specs.size
        image = var.server_specs.image
        region = var.server_specs.region
    }
}
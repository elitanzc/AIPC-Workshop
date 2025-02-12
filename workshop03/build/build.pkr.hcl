# the top-level source block defines reusable builder configuration blocks
source "digitalocean" "mydroplet" {
    api_token = var.DO_token
    ssh_username = "root"
    snapshot_name = var.snapshot_name
    size = var.server_specs.size
    image = var.server_specs.image
    region = var.server_specs.region
}

build {
    sources = [ "source.digitalocean.mydroplet" ]

    provisioner "ansible" {
        playbook_file = "./ansible/playbook.yaml"
        inventory_directory = "./ansible/inventory/"
        # # Can also specify extra args that references vars declared in variables.pkr.hcl
        # extra_arguments = [
        #     "-e", 
        #     "code_server_archive=${var.code_server_archive}",
        # ]
    }
}
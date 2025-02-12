# This is to declare the variables like variables.tf in terraform

########## Digital Ocean Config variables ##########
variable "DO_token" {
    type = string
    description = "DigitalOcean token, used in Providers"
    sensitive = true
}

# # This var can used by playbook.yaml, but nahh too messy to include it here
# variable "code_server_archive" {
#     type = string
#     description = "The download link of code server archive"
#     default = "https://github.com/coder/code-server/releases/download/v4.96.4/code-server-4.96.4-linux-amd64.tar.gz"
# }

########## Digital Ocean Droplet variables ##########
# Default: Ubuntu 20.04 with at least 2GB RAM
variable "server_specs" {
    type = object({
        size = string
        image = string
        region = string
    })
    default = {
        size = "s-1vcpu-2gb"
        image = "ubuntu-20-04-x64"
        region = "sgp1"
    }
}

variable "snapshot_name" {
    type = string
    description = "Name of the snapshot to create"
    default = "workshop03-snapshot"
}
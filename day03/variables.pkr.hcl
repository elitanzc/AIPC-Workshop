# This is to declare the variables like variables.tf in terraform
variable "DO_token" {
  type = string
  description = "DigitalOcean token, used in Providers"
  sensitive = true # terraform will not print/ log it out
}

# # defined in terraform.tfvars
# variable "private_key_filepath" {
#     type = string
#     description = "Path to private key in local (fred)"
#     sensitive = true
# }

# variable "DO_public_key_name" {
#     type = string
#     description = "Name of the ssh public key registered in DigitalOcean"
#     default = "fred"
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
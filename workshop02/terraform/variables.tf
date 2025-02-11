# defined in terraform.tfvars
variable "DO_token" {
  type = string
  description = "DigitalOcean token, used in Providers"
  sensitive = true # terraform will not print/ log it out
}

# defined in terraform.tfvars
variable "private_key_filepath" {
    type = string
    description = "Path to private key in local (fred)"
    sensitive = true
}

variable "DO_public_key_name" {
    type = string
    description = "Name of the ssh public key registered in DigitalOcean"
    default = "fred"
}


########## Digital Ocean Droplet variables ##########
# see https://slugs.do-api.dev/ for for values

# # Ubuntu 20.04 with at least 2GB RAM
variable "droplet_size" {
    type = string
    default = "s-1vcpu-2gb"
}
variable "droplet_image" {
    type = string
    default = "ubuntu-20-04-x64"
}
variable "droplet_region" {
    type = string
    default = "sgp1"
}
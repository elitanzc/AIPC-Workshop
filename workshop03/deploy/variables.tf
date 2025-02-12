# This is to declare the variables like variables.tf in terraform

########## Digital Ocean Config variables ##########
variable "DO_token" {
    type = string
    description = "DigitalOcean token, used in Providers"
    sensitive = true
}

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

########## Code Server app variables ##########

variable "code_server_password" {
    type = string
    description = "Password for code server"
    sensitive = true
}

########## Digital Ocean Droplet variables ##########
# At least 2GB RAM, image will be using snapshot
variable "server_specs" {
    type = object({
        size = string
        region = string
    })
    default = {
        size = "s-1vcpu-2gb"
        region = "sgp1"
    }
}
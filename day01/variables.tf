# this var is set in terraform.tfvars
variable "DO_token" {
  type = string
  description = "DigitalOcean token, used in Providers"
  sensitive = true # terraform will not print/ log it out
}

variable "DO_public_key_name" {
    type = string
    description = "Name of the ssh public key registered in DigitalOcean"
    default = "fred" #"work1"
}

variable "private_key_filepath" {
    type = string
    default = "/home/fred/.ssh/id_ed25519_nopw"
    sensitive = true
}


########## Digital Ocean Droplet variables ##########
# see https://slugs.do-api.dev/ for for values
variable "droplet_size" {
    type = string
    default = "s-1vcpu-1gb"
}
variable "droplet_image" {
    type = string
    default = "ubuntu-24-04-x64"
}
variable "droplet_region" {
    type = string
    default = "sgp1" # singapore region
}
variable "instance_count" {
  type = number # can also be boolean/ object
  default = 2
}

variable "servers" {
  type = map(
    object({
        size  = string
        image = string
    })
  )
  default = {
    myserver-512mb = {
      size  = "s-1vcpu-512mb-10gb"
      image = "ubuntu-22-04-x64"
    }
    myserver-1gb = {
      size  = "s-1vcpu-1gb"
      image = "ubuntu-24-10-x64"
    }
  }
}
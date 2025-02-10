# this var is set in terraform.tfvars
variable "DO_token" {
  type = string
  description = "DigitalOcean token, used in Providers"
  sensitive = true # terraform will not print/ log it out
}

variable "DO_public_key_name" {
    type = string
    description = "Name of the ssh public key registered in DigitalOcean"
    default = "work1"
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
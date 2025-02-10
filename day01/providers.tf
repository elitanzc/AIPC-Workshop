terraform {
    required_version = ">= v1.10.0"
    required_providers {

        # set up the docker provider
        docker = {
            source = "kreuzwerker/docker"
            version = "3.0.2"
        }

        # set up local provider
        local = {
            source = "hashicorp/local"
            version = "2.5.2"
        }

        digitalocean = {
            source = "digitalocean/digitalocean"
            version = "2.48.2"
        }
    }
}

### Blobs for every required providers:

# https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs
provider "docker" {
    host = "unix:///var/run/docker.sock"
}

# https://registry.terraform.io/providers/hashicorp/local/latest/docs
provider "local" { }

provider "digitalocean" {
    token = var.DO_token
}
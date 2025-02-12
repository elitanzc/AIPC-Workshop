# This file installs the plugins

packer {
    required_plugins {
        digitalocean = {
            source = "github.com/hashicorp/digitalocean"
            version = ">= 1.0.0"
        }
        ansible = {
            version = "~> 1"
            source = "github.com/hashicorp/ansible"
        }
    }
}
data "digitalocean_ssh_key" "DO_public_key_name" {
  name = var.DO_public_key_name # using fred
}

########## Resources ##########

# docker
resource "docker_network" "bgg_net" {
  name = "bgg-net"
}

# docker images
resource "docker_image" "bgg_database_image" {
  name = "chukmunnlee/bgg-database:v3.1"
}
resource "docker_image" "bgg_backend_image" {
  name = "chukmunnlee/bgg-backend:v3"
}

resource "docker_volume" "bgg_database_volume" {
  name = "bgg-db-volume"
}

# docker containers
resource "docker_container" "bgg_database_container" {
  name = "bgg-database"
  image = docker_image.bgg_database_image.image_id
  volumes {
    container_path = "/var/lib/mysql"
    volume_name = docker_volume.bgg_database_volume.name
  }
  ports {
    internal = 3306
    external = 3306
  }
  networks_advanced {
    name = docker_network.bgg_net.name
  }
}

resource "docker_container" "bgg_backend_container" {
  count = 3
  name = "bgg-backend-${count.index}"
  image = docker_image.bgg_backend_image.image_id
  env = [
    "BGG_DB_USER=root",
    "BGG_DB_PASSWORD=changeit",
    "BGG_DB_HOST=${docker_container.bgg_database_container.name}"
  ]
  ports {
    internal = 3000
    external = sum([3000, count.index])
  }
  networks_advanced {
    name = docker_network.bgg_net.name
  }
}

# config file generated from bgg-backend external ports
resource "local_file" "nginx_conf" {
  filename = "nginx.conf"
  content = templatefile("nginx.conf.tftpl", {
    docker_host_ip = var.docker_host_ip
    ports = docker_container.bgg_backend_container[*].ports[0].external
    # endpoints = [
    #   for container in docker_container.bgg_backend_container: 
    #     "${container.network_data[0].ip_address}:${container.ports[0].external}"
    # ]
  })
}

# nginx server
resource "digitalocean_droplet" "nginx" {
    name = "nginx"
    image = var.droplet_image
    size = var.droplet_size
    region = var.droplet_region
    ssh_keys = [
        data.digitalocean_ssh_key.DO_public_key_name.id
    ]

    connection {
      type = "ssh"
      private_key = file(var.private_key_filepath)
      user = "root"
      host = self.ipv4_address
    }

    # installs nginx
    provisioner "remote-exec" {
      inline = [ 
        "apt update -y", 
        "apt upgrade -y",
        "apt install -y nginx",
        "systemctl start nginx",
        "systemctl enable nginx"
      ]
    }
    # replace the /etc/nginx/nginx.conf on the reverse proxy with own nginx.conf
    provisioner "file" {
      source = "nginx.conf"
      destination = "/etc/nginx/nginx.conf"
    }

    # signal nginx to reload the new configuration
    provisioner "remote-exec" {
      inline = [ 
        "/usr/sbin/nginx -s reload",
        "systemctl restart nginx"
      ]
    }
}

output "nginx_ipv4" {
  value = digitalocean_droplet.nginx.ipv4_address
}
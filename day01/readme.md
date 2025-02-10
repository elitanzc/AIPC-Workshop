# Notes

## Variables
- Terraform will log the variables by default, can set `sensitive = true` to prevent printing the var.

### terraform.tfvars
This is the tfvar file that will be used if `-var-file=xxx.tfvars` option is not specified.
Do exclude this file from git commits if storing sensitive vars like `DO_token`.

## Dependency graph
Can see tf dependencies by doing:
```
terraform graph | dot -Tpng > graph.png
```
requires: `apt install graphwiz`

## Count
Count kind of coverts a resource bloc into an array of resources, each one can be accessed by index.

e.g.
```
resource "digitalocean_droplet" "droplet-day01" {
    count = 3
    name = "droplet-day01-${count.index}"
    ...
}

output "droplet-day01-ipv4" {
    description = "Droplet public IP address of first droplet"
    value = digitalocean_droplet.droplet-day01[0].ipv4_address
}
```

Can only create top-level resources.

## for_each
Used in 2 ways:
1. replicate/ create multiple at resource level
2. dynamically create attribute blocks within a resource, e.g.:
    ```
    variable attributes {
        type = map(
            object({
                xxx = string
                yyy = string
            })
        )
        default = {
            attribute1 = {
                xxx = ""
                yyy = ""
            }
            attribute2 = {
                xxx = ""
                yyy = ""
            }
        }
    }
    resource ... {
        dynamic "attribute_name" {
            for_each = var.attributes
            iterator = iterator_name # changes iterator from each (default) to iterator_name
            content = {
                xxx = iterator_name.value.xxx
                yyy = iterator_name.value.yyy
            }
        }
    }
    ```
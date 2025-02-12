## In `/build`:
- `build.pkr.hcl` is the main file that specifies how the snapshot is built
- `variables.pkr.hcl` declares all the variables needed inside `build.pkr.hcl`. Most variables have their defaults being set, except for `DO_token`.
- 2 methods to pass in values of variables:
    - [Option 1] Create `variables.pkrvars.hcl` containing a line `DO_token = <your own Digital Ocean token>`. Then run:
        ```
        packer init config.pkr.hcl
        packer build -var-file=variables.pkrvars.hcl .
        ```
    - [Option 2] Pass the variable in the command:
        ```
        packer init config.pkr.hcl
        packer build \
            -var "DO_token=<your own Digital Ocean token>" \
            .
        ```
- `/ansible` contains the stuffs for ansible.
    - `playbook.yaml` is the blueprint that will be applied on the tmp server (auto created by `packer`) that is used to create the snapshot.
    - The variables inside `playbook.yaml` are defined in `/inventory/host_vars/default.yaml`. It is like the former `inventory.yaml` in workshop02, but minus the `hosts`. Just a flat list of variables. Good when there are many variables inside `playbook.yaml`. If there are only a few vars, can pass through the `extra_arguments` param of `build > provisioner "ansible"` in `build.pkr.hcl`. 

## In `/deploy`:
- Create `terraform.tfvars` and set the variables:
    - `DO_token`
    - `private_key_filepath`
    - `DO_public_key_name`
    - `code_server_password`
- The code server has 2 custom vars: `CODE_SERVER_PASSWORD` and `CODE_SERVER_DOMAIN`.
    - `CODE_SERVER_PASSWORD` is being specified inside `terraform.tfvars`
    - `CODE_SERVER_DOMAIN` requires the ipv4 address of the provisioned server
    - these 2 vars will be set by doing `remote-exec` when server is being provisioned by terraform, using the `provisioner` block inside the server resource.
- As usual do `terraform init && terraform apply -auto-approve` to deploy.
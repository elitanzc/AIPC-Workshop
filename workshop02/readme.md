1. In the folder `terraform`:
    - Create `terraform.tfvars` and set the variables:
        - `DO_token`
        - `private_key_filepath`
        - `DO_public_key_name`
        - `code_server_password`
    - Provision the server and create `inventory.yaml` from `inventory.yaml.tftpl` template by running
        ```
        terraform init
        terraform apply -auto-approve
        ```
2. Run the following to configure server following steps in `steps.txt`
    ```
    ansible-playbook playbook.yaml -i inventory.yaml
    ```
3. Site can be accessed at code-<ansible_host_ip>.nip.io, where ansible_host_ip is the ip of the server created in step 1. Can also ssh into the ansible host by running
    ```
    ssh -i <path_to_private_key> root@*
    ```
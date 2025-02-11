# Notes

## Ansible
Control host must be Linux/ Mac.
Target host can be Linux/ Windows/ ONX. Anything that can ssh in to execute some commands.

### inventory.yaml
```
ansible-inventory -i inventory.yaml --graph --vars
ansible <all/ {group}/ {host}> -i inventory.yaml -m ping # validate connection
ansible <all/ {group}/ {host}> -i inventory.yaml -m setup | less # gather info about the remote host(s)
```

`hosts` lists all servers
`children` lists all groups
`children` overrides `hosts`, `hosts` overrides `vars`

Encrypting it:
```
ansible-vault encrypt inventory.yaml
ansible-vault view inventory.yaml
ansible-playbook all -i inventory.yaml playbook.yaml --ask-vault-pass
```

### playbook.yaml
```
ansible-playbook playbook.yaml -i inventory.yaml
```

https://docs.ansible.com/ansible/latest/reference_appendices/playbooks_keywords.html


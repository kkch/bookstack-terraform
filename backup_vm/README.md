## Provisioning Backup VM for Bookstack in Eu cloud

Ansible scripts to provision backup  VM for Bookstack App

## Requirements
 - You will need to define `clouds.yaml` for your openstack clouds. 

## Usage

```bash
ansible-playbook -u ubuntu -i <floating ip of VM>, playbook.yaml
```

This ansible playbook creates a VM in EU cloud, you can change all the parameters like `vm_name`, `image`, `floating_ip_address` etc in `instance_vars.yaml` file. 

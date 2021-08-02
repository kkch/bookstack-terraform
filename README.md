## Terraform and Ansible Automation script to launch Bookstack in Openstack env

## Bookstack

Bookstack is Opensource documentation tool.

- [Bookstack](https://www.bookstackapp.com)

- [Github](https://github.com/BookStackApp/BookStack)

For this deployment I have used docker image from Linuxserver.io 

- [Linuxserver.io](https://github.com/linuxserver/docker-bookstack)

## Prerequisites

You will need following packages installed and following configurations on your local machine or where ever you intend to run this scripts from. 

Most of these packages are available in your dist package manager:

- [Terraform](https://www.terraform.io/downloads.html)

- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html)

You will need to configure `clouds.yaml` for Terraform to authenticate with OpenStack, Here is how to on [clouds.yaml](https://docs.openstack.org/python-openstackclient/latest/configuration/index.html)

specify correct cloud name inside each `*/providers.tf` file.

## Lead

```
├── backup_bookstack
├── backup.j2
├── backup_vm
│   ├── instance_vars.yaml
│   ├── instance.yaml
│   ├── keys
│   │   ├── kkch.pub
│   ├── lvm.yaml
│   ├── playbook.yaml
│   ├── README.md
│   ├── users.yaml
│   └── user_vars.yaml
├── backup.yaml
├── bookstack_vars.yaml
├── bookstack.yaml
├── env.j2
├── install-docker.yaml
├── kb.example.com
├── lvm.yaml
├── main.tf
├── modules
│   ├── image
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── terraform.tfstate
│   │   └── variables.tf
│   ├── instance_attach_volume
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   └── variables.tf
│   ├── key
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   └── variables.tf
│   ├── network
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   └── variables.tf
│   ├── server
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   └── variables.tf
│   └── volume
│       ├── main.tf
│       ├── outputs.tf
│       ├── providers.tf
│       └── variables.tf
├── outputs.tf
├── providers.tf
├── README.md
└── vault.yaml
```

- `backup_bookstack`  is cron job config file which will be copied to over to `/etc/cron.d/` by Ansible.

- `back.sh` is the actual backup script, which is run at regular intervals by cron job.

- `backup_vm` has Ansible playbooks to provision an instance in different cloud or availability zone with a volume attached. 

- `backup.yaml` is Ansible playbook which is responsible to copy over `backup_bookstack`  and `backup.sh` files over to server.

- `bookstack.yaml` is Ansible playbook what is responsible for all post server provision tasks like, install needed packages, copy configs etc etc

- `bookstack_vars.yaml` holds variable for `bookstack.yaml` playbook.

- `docker-compose.yaml` is docker compose file which Ansible playbook uses to launch Bookstack containers 

- `.env` file holds LDAP configuration and is copied over to Bookstack container config path during Ansible playbook play.

- `modules` directory contains all the Terraform modules, 
  
  -  `image` - Module downloads an Ubuntu 20.04 image from Ubuntu servers and creates an image in OpenStack
  
  - `key` - Module creates a Key pair in OpenStack
  
  - `network` - Module creates a floating IP and associates the same to sever (Required)
  
  - `server` - Module creates a server in OpenStack

- `outputs.tf` file where output logic for Terraform is defined

- `providers.tf` file holds Terraform provider config

- `variables.tf` file holds variables for respective module 

- `main.tf` file holds the main config for Terraform and this file is called when you run `terraform plan` , `terraform init` and `terraform apply `

- `ssl` directory contains ssl certs.

- `kb.example.com` file contains Nginx configuration for the Bookstack application. 
  
  

## Usage

At the minimum to launch Bookstack app you will need following in your `main.tf` file:

This will create a server with provided `image_id`, `key_pair`  and `server_name` , server created here will use `KB-SG` Security group and `m1-medium` flavor. 

```bash
module "server" {
  source        = "./modules/server"
  server_name   = <server_name>
  image_id      = <Image_id>
  key_pair_name = <key_pair_name>
}

module "network" {
  source      = "./modules/network"
  instance_id = module.server.server_out

}
resource "null_resource" "ansible" {
  provisioner "remote-exec" {
    inline = [
         "echo 'host is up and running'"
    ]
    connection {
      host        = module.network.floating_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("<path to private key >")
    }
  }
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=FALSE ansible-playbook -u ubuntu -i '${module.network.floating_ip}', --vault-password-file=.vault_pass bookstack.yaml"
  }
}
```

`remote-exec` checks if `ssh` service is ready and accessible on newly provisioned server and `local-exec` is responsible for calling Ansible playbook.

You may include `key` and `image` module if you need to create a new image and a Key-pair in OpenStack. 

## Important

- Backup jobs are handled by `rsync` tool, all this config can be found in `backup.j2` file. 

- Please make sure you change `floating_ip` address of backup server in `backup.j2` file. 

- This script does not run `backup_vm`  Ansible scripts. you will need to manually run the Ansible playbook, see `README.md` file in the `backup_vm` directory. 

- encrypt sensitive data like `mysql` user password with `ansible-valut` when possible. for example `vault.yaml` file. 

- Place your ssl certs in `ssl` directory. 

## Admin access on fresh deployment

- You can use following credentials to get admin access when LDAP is not enabled for authentication 
  
  - username : admin@admin.com
  
  - password : password
  
  

module "server" {
  source        = "./modules/server"
  server_name   = "sre-bookstack"
  image_id      = "<image_id>"
  key_pair_name = "<key_pair_name>"

}

module "instance_attach_volume"{
  source = "./modules/instance_attach_volume"
  instance_id = module.server.server_out
  volume_id = module.volume.volume_out

}

module "volume" {
  source = "./modules/volume"
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


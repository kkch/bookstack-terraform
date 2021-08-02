
resource "openstack_compute_instance_v2" "bookstack" {

  name            = var.server_name
  image_id        = var.image_id
  flavor_name     = var.flavor_name
  key_pair        = var.key_pair_name
  security_groups = var.security_group_name[*]

  network {
    name = var.network_name
  }
}

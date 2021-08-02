resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = var.network_pool
}
resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = openstack_networking_floatingip_v2.fip_1.address
  instance_id = var.instance_id
}
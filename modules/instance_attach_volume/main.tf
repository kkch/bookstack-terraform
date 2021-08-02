
resource "openstack_compute_volume_attach_v2" "va_1" {

  instance_id       = var.instance_id
  volume_id        = var.volume_id
}

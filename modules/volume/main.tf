
resource "openstack_blockstorage_volume_v2" "volume_1" {

  name            = var.volume_name
  description        = var.volume_description
  size = var.volume_size
}

resource "openstack_images_image_v2" "ubuntu20" {
  name             = "ubuntu-20.04-amd64"
  image_source_url = "https://cloud-images.ubuntu.com/focal/20210401/focal-server-cloudimg-amd64.img"
  container_format = "bare"
  disk_format      = "qcow2"
}

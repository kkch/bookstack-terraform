output "attach_volume_out" {
  value = openstack_compute_volume_attach_v2.attachments.va_1.id
}

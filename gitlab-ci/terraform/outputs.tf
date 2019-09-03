output "external_ip" {
  value = "${module.app.app_external_ip}"
}

output "dyn_inv" {
  value = "${template_file.dyn_inv.rendered}"
}

output "streamlit_url" {
  value = "http://${google_compute_instance.streamlit_vm.network_interface.0.access_config.0.nat_ip}:8501"
}

output "kestra_url" {
  value = "http://${google_compute_instance.streamlit_vm.network_interface.0.access_config.0.nat_ip}:8080"
}
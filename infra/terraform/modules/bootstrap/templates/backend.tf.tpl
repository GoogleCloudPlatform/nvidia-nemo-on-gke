terraform {
  backend "gcs" {
    bucket                      = "${bucket}"
    %{~ if backend_extra != null ~}
    ${indent(4, backend_extra)}
    %{~ endif ~}
  }
}

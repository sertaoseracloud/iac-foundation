output "aad_audience" {
    value = azuread_application_registration.this.client_id
}
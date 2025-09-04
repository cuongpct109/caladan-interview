output "current_public_ip" {
  value = "${chomp(data.http.my_ip.response_body)}/32"
}
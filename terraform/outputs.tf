output "instance_public_ip" {
  value = aws_instance.p9.public_ip
}

output "instance_id" {
  value = aws_instance.p9.id
}

output "ssh_key_path" {
  description = "Private key location (not in git)"
  value       = "${path.module}/../ansible/p9-key.pem"
  sensitive   = true
}

output "inventory_path" {
  value = "${path.module}/../ansible/inventory.ini"
}

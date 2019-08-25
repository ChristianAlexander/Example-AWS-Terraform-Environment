output "public_instance_ip" {
  value = aws_instance.a.public_ip
}

output "private_instance_ip" {
  value = aws_instance.b.private_ip
}

output "ssh_config_addition" {
  value = data.template_file.ssh_config.rendered
}

output "ssh_command" {
  value = "ssh ubuntu@${aws_instance.b.private_ip}"
}

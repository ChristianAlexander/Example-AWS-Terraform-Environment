
Host ${private_instance_ip}
  IdentityFile ${key_file_path}
  ProxyCommand ssh ubuntu@${public_instance_ip} -W %h:%p

Host ${public_instance_ip}
  IdentityFile ${key_file_path}

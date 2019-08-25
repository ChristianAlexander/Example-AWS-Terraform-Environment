locals {
  my_ip_cidr = "${trimspace(data.http.my_ip.body)}/32"
}

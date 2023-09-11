resource "aws_instance" "instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_groups

  tags = {

    Name = var.name
  }

}

resource "aws_route53_record" "record" {
  name        = "${var.name}.soujandevops.online"
  type        = "A"
  zone_id     = var.zone_id
  ttl         = 30
  records     = [ aws_instance.instance.private_ip]
}


resource "null_resource" "anisible" {

  depends_on = [
    aws_route53_record.record
  ]

  provisioner "local-exec" {

    command = <<EOF
cd /home/centos/roboshop-ansible
git pull
sleep 30
ansible-playbook -i ${var.name}.soujandevops.online, main.yml -e ansible_user=centos -e ansible_password=DevOps321 -e component=${var.name}

EOF
  }
}
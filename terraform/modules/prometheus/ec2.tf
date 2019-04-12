resource "aws_instance" "redis_server" {
  instance_type          = "${var.instance_type}"
  ami                    = "${var.ami}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.redis.id}"]
  subnet_id              = "${aws_subnet.public_subnet.id}"

  provisioner "local-exec" {
     command =  "echo ${aws_instance.redis_server.public_ip} > ../redis_ansible/hosts"
  }
}

resource "aws_instance" "prometheus_server" {
  instance_type          = "${var.instance_type}"
  ami                    = "${var.ami}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.prometheus.id}"]
  subnet_id              = "${aws_subnet.public_subnet.id}"

  provisioner "local-exec" {
     command =  "echo ${aws_instance.prometheus_server.public_ip} > ../prometheus_ansible/hosts"
  }
}

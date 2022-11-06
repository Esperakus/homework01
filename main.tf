terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.13"
    }
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
  token     = var.yc_token
}

resource "yandex_compute_instance" "nginx01" {
  name     = "nginx-server"
  hostname = "nginx-server"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet01.id
    nat       = true
  }

  metadata = {
    ssh-keys = "cloud-user:${file("~/.ssh/id_rsa.pub")}"
#    user-data = "${file("user_data.txt")}"
  }

  connection {
    type        = "ssh"
    user        = "cloud-user"
    private_key = "${file("~/.ssh/id_rsa")}"
    host        = yandex_compute_instance.nginx01.network_interface.0.nat_ip_address
  }

  provisioner "remote-exec" {
    inline = ["echo 'Im ready!'"]

  }

  provisioner "local-exec" {
    command = "ansible-playbook -u cloud-user -i '${self.network_interface.0.nat_ip_address},' --private-key ~/.ssh/id_rsa nginx-centos.yml"
  }
}

resource "yandex_vpc_network" "net01" {
  name = "net01"
}

resource "yandex_vpc_subnet" "subnet01" {
  name           = "subnet1"
  zone           = var.zone
  network_id     = yandex_vpc_network.net01.id
  v4_cidr_blocks = ["192.168.100.0/24"]
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.nginx01.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.nginx01.network_interface.0.nat_ip_address
}
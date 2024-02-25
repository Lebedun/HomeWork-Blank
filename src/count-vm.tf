resource "yandex_compute_instance" "web_vm" {
  name        = "web-${count.index}"
  platform_id = var.count-vm-platform
  
  count = var.count-vm-count
  
  resources {
    cores  = var.count-vm-cores
    memory = var.count-vm-memory
    core_fraction = var.count-vm-core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image_name.image_id
      type = var.count-vm-boot_disk-type
      size = var.count-vm-boot_disk-size
    }   
  }

  metadata = {
    ssh-keys = var.vms_metadata.ssh-keys
  }

  scheduling_policy { preemptible = true }

  network_interface { 
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  allow_stopping_for_update = true
}

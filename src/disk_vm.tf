resource "yandex_compute_disk" "task_3_disk" {
  
    name   = "disk-${count.index}"
    count = 3
    type  = "network-hdd"
    zone  = "ru-central1-a"
    size  = 1
}

resource "yandex_compute_instance" "web_storage" {
  name        = "storage"
  platform_id = "standard-v1"
  depends_on = [yandex_compute_disk.task_3_disk]

  resources {
    cores  = 2
    memory = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      type = "network-hdd"
      size = 5
    }   
  }

    dynamic "secondary_disk" {
        for_each = yandex_compute_disk.task_3_disk
        content {
            ##disk_id = yandex_compute_disk.task_3_disk[secondary_disk.value.name].id
            disk_id = secondary_disk.value.id
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
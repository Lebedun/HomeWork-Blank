resource "yandex_compute_disk" "task_3_disk" {
  
    name   = "disk-${count.index}"
    count = var.task_3_disk-count
    type  = var.task_3_disk-type
    zone  = var.default_zone
    size  = var.task_3_disk-size
}

resource "yandex_compute_instance" "web_storage" {
  name        = "storage"
  platform_id = var.disk-vm-platform
  depends_on = [yandex_compute_disk.task_3_disk]

  resources {
    cores  = var.disk-vm-cores
    memory = var.disk-vm-memory
    core_fraction = var.disk-vm-core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image_name.image_id
      type = var.disk-vm-boot_disk-type
      size = var.disk-vm-boot_disk-size
    }   
  }

    dynamic "secondary_disk" {
        for_each = yandex_compute_disk.task_3_disk
        content {
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
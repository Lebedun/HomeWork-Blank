resource "yandex_compute_instance" "for_each_vm" {

    for_each = var.each_vm_params_notype

    depends_on = [yandex_compute_instance.web_vm]

    name = each.value.name

    platform_id = var.for_each-vm-platform

    resources {
        cores  = each.value.cores
        memory = each.value.memory
        core_fraction = var.for_each-vm-core_fraction
    }

    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.image_name.image_id
            type = "network-hdd"
            size = each.value.disk_volume
        }   
    }

    metadata = { ssh-keys =file("~/.ssh/id_rsa_ubuntu.pub") }
    ##metadata = { ssh-keys = var.vms_metadata.ssh-keys }

    scheduling_policy { preemptible = true }

    network_interface { 
        subnet_id = yandex_vpc_subnet.develop.id
        nat       = true
    }

    allow_stopping_for_update = true
}

each_vm_params_notype = {
  main = {
    name        = "main",
    cores       = 4,
    memory      = 4,
    disk_volume = 40,    
  }
  replica = {
    name        = "replica",
    cores       = 2,
    memory      = 2,
    disk_volume = 20,    
  }
}

count-vm-platform    = "standard-v1"
count-vm-count = 2
count-vm-cores = 2
count-vm-memory = 1
count-vm-core_fraction = 5
count-vm-boot_disk-type = "network-hdd"
count-vm-boot_disk-size = 5

for_each-vm-platform = "standard-v1"
for_each-vm-core_fraction = 5


disk-vm-platform    = "standard-v1"
disk-vm-cores = 2
disk-vm-memory = 1
disk-vm-core_fraction = 5
disk-vm-boot_disk-type = "network-hdd"
disk-vm-boot_disk-size = 5

task_3_disk-count = 3
task_3_disk-type = "network-hdd" 
task_3_disk-size = 1

image_name_string = "ubuntu-2004-lts"
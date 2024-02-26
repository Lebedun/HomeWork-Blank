resource "local_file" "ansible_hosts" {
    depends_on = [ yandex_compute_instance.web_vm, yandex_compute_instance.for_each_vm, yandex_compute_instance.web_storage ]
    content = templatefile("./hosts.tftpl", 
    { 
        webservers = yandex_compute_instance.web_vm
        databases = yandex_compute_instance.for_each_vm
        storages = [yandex_compute_instance.web_storage]
    })
    filename = "ansible_hosts"
}
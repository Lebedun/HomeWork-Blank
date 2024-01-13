output "vm_info" {
value = join("\n", [yandex_compute_instance.platform_web.name, 
                    yandex_compute_instance.platform_web.fqdn, 
                    yandex_compute_instance.platform_web.network_interface[0].nat_ip_address,
                    yandex_compute_instance.platform_db.name, 
                    yandex_compute_instance.platform_db.fqdn,
                    yandex_compute_instance.platform_db.network_interface[0].nat_ip_address]
            )
}

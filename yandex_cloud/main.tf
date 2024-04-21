resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.0.0/16"]
}

# module "kube" {
#   source = "../../"
#   network_id = yandex_vpc_network.network-1.id

#   master_locations = [
#     {
#       zone      = "ru-central1-a"
#       subnet_id = yandex_vpc_network.subnet-1.id
#     }
#   ]

#   master_maintenance_windows = [
#     {
#       day        = "monday"
#       start_time = "20:00"
#       duration   = "3h"
#     }
#   ]

#   node_groups = {
#     "yc-k8s-ng-01" = {
#       description = "Kubernetes nodes group 01 with fixed 1 size scaling"
#       auto_scale = {
#         min     = 2
#         max     = 4
#         initial = 2
#       }
#     },
#     "yc-k8s-ng-02" = {
#       description = "Kubernetes nodes group 02 with auto scaling"
#       fixed_scale = {
#         size = 3
#       }
#     }
#   }
# }
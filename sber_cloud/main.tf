terraform {
  required_providers {
    sbercloud = {
      source = "sbercloud-terraform/sbercloud"
    }
  }
}

provider "sbercloud" {
  auth_url = "https://iam.ru-moscow-1.hc.sbercloud.ru/v3"
  region   = "ru-moscow-1"

  access_key   = var.access_key
  secret_key   = var.secret_key
  project_name = var.iam_project_name
}

resource "sbercloud_vpc" "vpc_01" {
  name = "vpc_quickstart"
  cidr = "192.168.0.0/16"
}

resource "sbercloud_vpc_subnet" "subnet_01" {

  name = "subnet_01"
  
  cidr       = "192.168.0.0/24"
  gateway_ip = "192.168.0.1"

  primary_dns   = "100.125.13.59"
  secondary_dns = "1.1.1.1"

  vpc_id = sbercloud_vpc.vpc_01.id
}

# Create CCE cluster
resource "sbercloud_cce_cluster" "cce_01" {
  name                   = "demo-cluster"
  flavor_id              = "cce.s2.small"
  container_network_type = "overlay_l2"
  multi_az               = true
  vpc_id                 = sbercloud_vpc.vpc_01.id
  subnet_id              = sbercloud_vpc_subnet.subnet_01.id
}

# Create CCE worker node(s)
resource "sbercloud_cce_node" "cce_01_node" {
  cluster_id        = sbercloud_cce_cluster.cce_01.id
  name              = "cce-worker"
  flavor_id         = "s6.large.2"
  availability_zone = "ru-moscow-1a"
  os                = "CentOS 7.6"
  key_pair          = "put_here_the_name_of_your_existing_key_pair"

  root_volume {
    size       = 50
    volumetype = "SAS"
  }

  data_volumes {
    size       = 100
    volumetype = "SAS"
  }
}
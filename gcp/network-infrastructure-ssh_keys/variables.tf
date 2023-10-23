//credentials
variable "credentials" {
  type        = string
  description = "Default credentials"
  default     = "<your path credentials json>"
}
//project
variable "project" {
  description = "Project name of the GCP"
  type        = string
  default     = "<your project id>"
}
//region
variable "region" {
  type        = string
  description = "Default region GCP"
  default     = "asia-northeast3"
}
//zone
variable "zone" {
  type        = string
  description = "Default zone"
  default     = "asia-northeast3-a"
}
//===========================================network====================================================================
variable "compute_network_name" {
type    = string
default = "compute-network"
}

variable "auto_create_subnetworks" {
type    = bool
default = false
}

variable "routing_mode" {
type    = string
default = "REGIONAL"
}

variable "mtu" {
type    = string
default = "1460"
}

variable "delete_default_routes_on_create" {
type    = bool
default = false
}

variable "timeouts_create" {
description = "Set timeouts for create. Default is 2 minutes."
type        = string
default     = "1m"
}

variable "timeouts_update" {
description = "Set timeouts for update. Default is 2 minutes."
type        = string
default     = "1m"
}

variable "timeouts_delete" {
description = "Set timeouts for delete. Default is 2 minutes."
type        = string
default     = "1m"
}

variable "timeouts_connect" {
  description = "Set timeouts for connect. Default is 2 minutes."
  type        = string
  default     = "1m"
}
//===================================subnetwork=========================================================================
variable "compute_subnetwork_name" {
type    = string
default = "compute-subnetwork"
}

variable "ip_cidr_range" {
type    = string
default = "10.10.2.0/24"
}

variable "private_ip_google_access" {
type    = bool
default = false
}

variable "stack_type" {
type    = string
default = "IPV4_ONLY"
}
//======================================================================================================================
variable "compute_router_name" {
type    = string
default = "compute-router"
}
//======================================================================================================================
variable "compute_router_nat_name" {
type    = string
default = "compute-router-nat"
}

variable "nat_ip_allocate_option" {
type    = string
default = "AUTO_ONLY"
}

variable "source_subnetwork_ip_ranges_to_nat" {
type    = string
default = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
//======================================================================================================================
variable "compute_address_name" {
type    = string
default = "compute-address"
}
//=======================================firewall=======================================================================
variable "compute_firewall_ingress_name" {
type    = string
default = "compute-firewall-ingress-name"
}

variable "compute_firewall_egress_name" {
type    = string
default = "compute-firewall-egress-name"
}

//Firewall rules
variable "firewall-ports-tcp-ingress" {
type        = list(string)
description = "ingress rules for ports tcp"
default     = ["0-65535"] // all ports
// default     = ["22", "1194", "3389"] custom ports
}

variable "firewall-ports-udp-ingress" {
type        = list(string)
description = "ingress rules for ports udp"
default     = ["0-65535"] // all ports
// default     = ["22", "1194", "3389"] custom ports
}

variable "source_ranges_firewall" {
description = "The firewall will apply only to traffic that has source IP address in these ranges."
type        = list(string)
default     = ["0.0.0.0/0"] // all ip address
// default     = ["<your ip address 1>/32", "<your ip address 2>/32"]
}

variable "firewall-ports-tcp-egress" {
type        = list(string)
description = "egress rules for ports tcp"
default     = ["0-65535"]
}

variable "firewall-ports-udp-egress" {
type        = list(string)
description = "egress rules for ports udp"
default     = ["0-65535"]
}

variable "destination_ranges_firewall" {
description = "A list of destination CIDR ranges that this firewall applies to."
type        = list(string)
default     = ["0.0.0.0/0"]
}
//=================================================type=================================================================
// 8 vCPUs, RAM 8 GiB
variable "machine_type_large_cpu" {
  type = string
  default = "e2-highcpu-8"
}

// 4 vCPUs, RAM 16 GiB
variable "machine_type_large_mem" {
  type = string
  default = "e2-standard-4"
}

// 8 vCPUs, RAM 32 GiB
variable "machine_type_large_mem_cpu" {
  type = string
  default = "e2-standard-8"
}

// 2 vCPUs, RAM 8 GiB
variable "machine_type_standart" {
  type = string
  default = "e2-standard-2"
}

// 2 vCPUs, RAM 1 GiB
variable "machine_type_micro" {
  type = string
  default = "e2-micro"
}

// 2 vCPUs, RAM 4 GiB
variable "machine_type_medium" {
  type = string
  default = "e2-medium"
}
//=================================================image================================================================
variable "image_ubuntu" {
  type = string
  default = "ubuntu-2204-jammy-v20230727"
}

variable "image_debian" {
  type = string
  default = "debian-12-bookworm-v20230724"
}

variable "image_centos" {
  type = string
  default = "centos-stream-9-v20230711"
}
//=================================================disk=================================================================
variable "size_boot_large" {
  type = string
  default     = "200"
}

variable "size_boot_standart" {
  type = string
  default     = "80"
}

variable "size_boot_small" {
  type = string
  default     = "40"
}

variable "size_boot_micro" {
  type = string
  default     = "20"
}

variable "type_boot_disk" {
  type = string
  default     = "pd-ssd"
}
//=================================================ssh==================================================================
variable "ssh_user" {
type = string
default     = "<your user>"
}

variable "ssh_port" {
type = string
default     = "22"
}

variable "ssh_key_private" {
  type = string
  default = "./source/ssh/id_rsa"
}

variable "ssh_key_pub" {
type = string
default = "./source/ssh/id_rsa.pub"
}

variable "ssh_dir" {
  type = string
  default = "./source/ssh/"
}

variable "type" {
type = string
default = "ssh"
}

variable "agent" {
type = bool
default = false
}

variable "timeout" {
type = string
default = "1m"
}

variable "agent_identity" {
type = bool
default = false
}
//=========================================================files========================================================

variable "zsh_config" {
  type = string
  default = "./source/.zshrc"
}

variable "script_config" {
  type = string
  default = "./source/script.sh"
}

variable "tmux_config" {
  type = string
  default = "./source/tmux.tar.gz"
}

variable "ansible_config" {
  type = string
  default = "./source/ansible_config.tar.gz"
}

variable "ssh_config" {
  type = string
  default = "./source/config"
}
//=======================================================srv============================================================
variable "instance_names" {
  default = ["srv1", "srv2", "srv3"]
}

variable "instance_ips" {
  default = ["10.10.2.12", "10.10.2.13", "10.10.2.14"]
}

variable "master_ip" {
  default = "10.10.2.2"
}

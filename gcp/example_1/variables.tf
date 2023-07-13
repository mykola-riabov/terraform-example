//credentials
variable "credentials" {
  type        = string
  description = "Default credentials"
  default     = "(Your path to the directory with credentials)"
}
//project
variable "project" {
  description = "Project name of the GCP"
  type        = string
  default     = "(The name of your project)"
}
//region
variable "region" {
  type        = string
  description = "Default region GCP"
  default     = "europe-west3"
}
//zone
variable "zone" {
  type        = string
  description = "Default zone"
  default     = "europe-west3-a"
}
//======================================================================================================================
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
description = "Set timeouts for create. Default is 5 minutes."
type        = string
default     = "5m"
}

variable "timeouts_update" {
description = "Set timeouts for update. Default is 5 minutes."
type        = string
default     = "5m"
}

variable "timeouts_delete" {
description = "Set timeouts for delete. Default is 5 minutes."
type        = string
default     = "5m"
}
//======================================================================================================================
variable "compute_subnetwork_name" {
type    = string
default = "compute-subnetwork"
}

variable "ip_cidr_range" {
type    = string
default = "10.10.10.0/24"
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
//======================================================================================================================
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
#default     = ["0-65535"]
default     = ["22", "1194", "3389"]
}

variable "firewall-ports-udp-ingress" {
type        = list(string)
description = "ingress rules for ports udp"
#default     = ["0-65535"]
default     = ["22", "1194", "3389"]
}

variable "source_ranges_firewall" {
description = "The firewall will apply only to traffic that has source IP address in these ranges."
type        = list(string)
default     = ["0.0.0.0/0"]
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
default     = ["(The IP address from which you will be accessing)"]
}
//======================================================================================================================
variable "machine_type" {
type = string
default = "e2-standard-2"
}

variable "machine_type_vpn" {
  type = string
  default = "e2-micro"
}

variable "machine_type_node" {
  type = string
  default = "e2-medium"
}


variable "image" {
type = string
default = "ubuntu-2204-jammy-v20220810"
}

variable "image-debian" {
  type = string
  default = "debian-11-bullseye-v20221206"
}

variable "size_boot_disk" {
type = string
default     = "80"
}

variable "type_boot_disk" {
type = string
default     = "pd-ssd"
}

variable "ssh_user" {
type = string
default     = "(SSH Your username)"
}

variable "ssh_port" {
type = string
default     = "22"
}

variable "ssh_key_private" {
  type = string
  default = "(Your path to the private SSH key)"
}

variable "ssh_key_pub" {
type = string
default = ".(Your path to the public SSH key)"
}

variable "zsh_config" {
type = string
default = "./source/zshrc"
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
default = "5m"
}

variable "agent_identity" {
type = bool
default = false
}
//======================================================================================================================

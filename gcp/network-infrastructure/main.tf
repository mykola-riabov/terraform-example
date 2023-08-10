/*============================\
|-----------------------------|
|     List of resources       |
|-----------------------------|
| - google_compute_network    |
| - google_compute_subnetwork |
| - google_compute_router     |
| - google_compute_router_nat |
| - google_compute_address    |
| - google_compute_firewall   |
| - google_compute_instance   |
| - google_compute_disk       |
| - google_secret_manager     |
\============================*/
//======================================================================================================================
resource "google_compute_network" "compute_network" {
  name                            = var.compute_network_name
  description                     = null
  auto_create_subnetworks         = var.auto_create_subnetworks
  routing_mode                    = var.routing_mode
  mtu                             = var.mtu
  delete_default_routes_on_create = var.delete_default_routes_on_create

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}

//======================================================================================================================
resource "google_compute_subnetwork" "compute_subnetwork" {
  name                     = var.compute_subnetwork_name
  ip_cidr_range            = var.ip_cidr_range
  description              = null
  network                  = google_compute_network.compute_network.name
  private_ip_google_access = var.private_ip_google_access
  stack_type               = var.stack_type

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }

  depends_on = [google_compute_network.compute_network]
}
//======================================================================================================================
resource "google_compute_router" "compute_router" {
  name    = var.compute_router_name
  network = google_compute_network.compute_network.name

  depends_on = [google_compute_network.compute_network]
}
//======================================================================================================================
resource "google_compute_router_nat" "compute_router_nat" {
  name                               = var.compute_router_nat_name
  router                             = google_compute_router.compute_router.name
  nat_ip_allocate_option             = var.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat

  log_config {
    enable = true
    filter = "ALL"
  }

  depends_on = [google_compute_router.compute_router]
}
//======================================================================================================================
resource "google_compute_address" "compute_address" {
  name       = var.compute_address_name
  depends_on = [google_compute_network.compute_network]
}
//======================================================================================================================
//---------------------------------
//Create google_compute_firewall for INGRESS
//---------------------------------
resource "google_compute_firewall" "compute_firewall_ingress" {
  name       = var.compute_firewall_ingress_name
  network    = google_compute_network.compute_network.name
  depends_on = [google_compute_network.compute_network]

  dynamic "allow" {
    for_each = var.firewall-ports-tcp-ingress
    content {
      ports    = [allow.value]
      protocol = "tcp"
    }
  }

  dynamic "allow" {
    for_each = var.firewall-ports-udp-ingress
    content {
      ports    = [allow.value]
      protocol = "udp"
    }
  }

  allow {
    protocol = "icmp"
  }

  source_tags   = ["compute-firewall-tags"]
  direction     = "INGRESS"
  source_ranges = var.source_ranges_firewall
}

//---------------------------------
//Create google_compute_firewall for EGRESS
//---------------------------------
resource "google_compute_firewall" "compute_firewall_egress" {
  name       = var.compute_firewall_egress_name
  network    = google_compute_network.compute_network.name
  depends_on = [google_compute_network.compute_network]

  allow {
    ports    = var.firewall-ports-tcp-egress
    protocol = "tcp"
  }

  allow {
    ports    = var.firewall-ports-udp-egress
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  direction          = "EGRESS"
  destination_ranges = var.destination_ranges_firewall
}
//======================================================================================================================
resource "google_compute_instance" "crypto-manage" {
  name         = "crypto-manage"
  machine_type = var.machine_type
  tags         = ["crypto-manage-srv"]

  boot_disk {
    initialize_params {
      image = var.image
      size = var.size_boot_disk
      type = var.type_boot_disk
    }
  }
  network_interface {
    network    = google_compute_network.compute_network.name
    subnetwork = google_compute_subnetwork.compute_subnetwork.name
    network_ip = "10.10.10.8"

 #   access_config {
 #     nat_ip = google_compute_address.compute_address.address
 #   }
  }
  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_key_pub)}"
  }

  depends_on = [google_compute_network.compute_network]

  service_account {
    scopes = ["cloud-platform"]
  }
  //======================================================================================================================
}
resource "google_compute_instance" "vpn-crypto" {
    name         = "vpn-crypto"
    machine_type = var.machine_type_vpn
    tags         = ["vpn-crypto-srv"]

    boot_disk {
      initialize_params {
        image = var.image
#        size = var.size_boot_disk
#        type = var.type_boot_disk
      }
    }
    network_interface {
      network    = google_compute_network.compute_network.name
      subnetwork = google_compute_subnetwork.compute_subnetwork.name
      network_ip = "10.10.10.2"

      access_config {
        nat_ip = google_compute_address.compute_address.address
      }
    }
    metadata = {
      ssh-keys = "${var.ssh_user}:${file(var.ssh_key_pub)}"
    }

    depends_on = [google_compute_network.compute_network]

    service_account {
      scopes = ["cloud-platform"]
    }
}

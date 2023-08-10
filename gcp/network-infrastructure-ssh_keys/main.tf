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
resource "tls_private_key" "generated_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "ssh_public_key" {
  value = tls_private_key.generated_ssh_key.public_key_openssh
}

output "ssh_private_key" {
  value = tls_private_key.generated_ssh_key.private_key_pem
  sensitive = true
}

resource "null_resource" "copy_ssh_keys" {
  triggers = {
    public_key = tls_private_key.generated_ssh_key.public_key_openssh
    private_key = tls_private_key.generated_ssh_key.private_key_pem
  }

  provisioner "local-exec" {
    command = "echo '${null_resource.copy_ssh_keys.triggers.private_key}' > ${var.ssh_key_private}"
  }

  provisioner "local-exec" {
    command = "chmod 600 ${var.ssh_key_private}"
  }

  provisioner "local-exec" {
    command = "echo '${null_resource.copy_ssh_keys.triggers.public_key}' > ${var.ssh_key_pub}"
  }

  provisioner "local-exec" {
    command = "chmod 600 ${var.ssh_key_pub}"
  }
}
//======================================================================================================================
resource "google_compute_instance" "master-srv" {
  name         = "master-srv"
  machine_type = var.machine_type_micro
  tags         = ["master-srv"]

  boot_disk {
    initialize_params {
      image = var.image_ubuntu
      size  = var.size_boot_micro
      type  = var.type_boot_disk
    }
  }
  network_interface {
    network    = google_compute_network.compute_network.name
    subnetwork = google_compute_subnetwork.compute_subnetwork.name
    network_ip = var.master_ip

    access_config {
      nat_ip = google_compute_address.compute_address.address
    }
  }
  metadata = {
    ssh-keys = "${var.ssh_user}:${tls_private_key.generated_ssh_key.public_key_openssh}"
  }

  depends_on = [
    google_compute_network.compute_network,
    tls_private_key.generated_ssh_key,
    null_resource.copy_ssh_keys
  ]

  service_account {
    scopes = ["cloud-platform"]
  }

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.ssh_key_private)
    host        = google_compute_address.compute_address.address
    timeout     = var.timeouts_connect
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p $HOME/.downloads",
    ]
  }

  provisioner "file" {
    source      = var.zsh_config
    destination = "/home/${var.ssh_user}/.downloads/.zshrc"
  }

  provisioner "file" {
    source      = var.script_config
    destination = "/home/${var.ssh_user}/.downloads/script.sh"
  }

  provisioner "file" {
    source      = var.tmux_config
    destination = "/home/${var.ssh_user}/.downloads/tmux.tar.gz"
  }

  provisioner "file" {
    source      = var.ansible_config
    destination = "/home/${var.ssh_user}/.downloads/ansible_config.tar.gz"
  }

  provisioner "file" {
    source      = var.ssh_config
    destination = "/home/${var.ssh_user}/.ssh/config"
  }

  provisioner "file" {
    source      = var.ssh_key_private
    destination = "/home/${var.ssh_user}/.ssh/id_rsa"
  }

  provisioner "file" {
    source      = var.ssh_key_pub
    destination = "/home/${var.ssh_user}/.ssh/id_rsa.pub"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.ssh_user}/.downloads/script.sh",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/${var.ssh_user}/.ssh/id_rsa",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "gcloud secrets create master-srv-ssh-privkey",
      "gcloud secrets create master-srv-ssh-pubkey",
      "gcloud secrets versions add master-srv-ssh-privkey --data-file=/home/${var.ssh_user}/.ssh/id_rsa",
      "gcloud secrets versions add master-srv-ssh-pubkey --data-file=/home/${var.ssh_user}/.ssh/id_rsa.pub",
    ]
  }
}
//======================================================================================================================
resource "google_compute_instance" "srv" {
  count        = length(var.instance_names)
  name         = var.instance_names[count.index]
  machine_type = var.machine_type_micro
  tags         = [var.instance_names[count.index]]

  boot_disk {
    initialize_params {
      image = var.image_ubuntu
      size   = var.size_boot_micro
      type   = var.type_boot_disk
    }
  }

  network_interface {
    network    = google_compute_network.compute_network.name
    subnetwork = google_compute_subnetwork.compute_subnetwork.name
    network_ip = var.instance_ips[count.index]
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${tls_private_key.generated_ssh_key.public_key_openssh}"
  }

  depends_on = [
    google_compute_network.compute_network,
    tls_private_key.generated_ssh_key,
    null_resource.copy_ssh_keys,
    google_compute_instance.master-srv
  ]

  service_account {
    scopes = ["cloud-platform"]
  }
//end
}

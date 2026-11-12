terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.70"
    }
  }

  backend "local" {
    path = "../../tmp/opentofu/terraform.tfstate"
  }
}

provider "hcloud" {}

variable "ssh_public_key" {
  description = "Public key forwarded by the local SSH agent."
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "IPv4 CIDR allowed to connect to SSH, usually your public IP with /32."
  type        = string
}

data "hcloud_primary_ip" "reserved" {
  ip_address = "157.180.32.185"
}

resource "hcloud_ssh_key" "operator" {
  name       = "foss-mom-dev"
  public_key = var.ssh_public_key
}

resource "hcloud_firewall" "server" {
  name = "foss-mom-hel1"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = [var.ssh_allowed_cidr]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_server" "hel1" {
  name        = "foss-mom-hel1"
  server_type = "cpx02"
  image       = "ubuntu-24.04"
  location    = "hel1"
  ssh_keys    = [hcloud_ssh_key.operator.name]
  firewall_ids = [
    hcloud_firewall.server.id,
  ]

  public_net {
    ipv4         = data.hcloud_primary_ip.reserved.id
    ipv4_enabled = true
    ipv6_enabled = false
  }

  labels = {
    purpose    = "throwaway"
    managed-by = "opentofu"
  }
}

output "server_ipv4" {
  description = "Reserved IPv4 assigned to the Helsinki server."
  value       = data.hcloud_primary_ip.reserved.ip_address
}
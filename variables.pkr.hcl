packer {
  required_plugins {
    qemu = {
      #version = "~> 1"
      version = " >= 1.0.0, < 2.0.0 " # me curo de espanto cuando salga la v2
      source  = "github.com/hashicorp/qemu"
    }
  }
}

variable "ubuntu_series" {
  type        = string
  default     = "jammy"
  description = "The Ubuntu release to build"
}

variable "ubuntu_iso" {
  type        = string
  default     = "ubuntu-22.04.3-live-server-amd64.iso"
  description = "The ISO name to build the image from"
}

variable "ssh_username" {
  type        = string
  default     = "ubuntu"
  description = "Username used during provisioning."
}

variable "ssh_password" {
  type        = string
  default     = "ubuntu"
  sensitive   = true
  description = "SSH password for the ssh_username. If you change this, then you MUST also modify ssh_password_crypted."
}

variable "ssh_password_crypted" {
  type        = string
  sensitive   = true
  default     = "$6$canonical.$0zWaW71A9ke9ASsaOcFTdQ2tx1gSmLxMPrsH0rF0Yb.2AEKNPV1lrF94n6YuPJmnUy2K2/JSDtxuiBDey6Lpa/"
  description = "SSH password for the ssh_username, crypted for /etc/shadow (e.g. using mkpasswd --method=SHA-512 --stdin). If you change this, then you MUST also modify ssh_password"
}

variable "vm_name" {
  type        = string
  default     = "ubuntu-example"
  description = "Full hostname your VM should have"
}

variable "locale" {
  type    = string
  default = "C.UTF-8"
}

variable "keyboard_layout" {
  type    = string
  default = "us"
}

variable "keyboard_variant" {
  type    = string
  default = ""
}



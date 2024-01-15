source "qemu" "stage2" {

  iso_checksum = "none"
  iso_url      = "${var.vm_name}-stage1.qcow2"
  disk_image   = true

  vm_name     = var.vm_name
  format      = "qcow2"
  accelerator = "kvm"   # default
  disk_size   = "5120M" # default 5G  (GiB)
  memory      = 4096    # default 512 (MiB)

  headless         = true
  shutdown_command = "echo '${var.ssh_password}' | sudo -S -- sh -c 'shutdown -P now'"
  #   shutdown_command = "echo '${var.ssh_password}' | sudo -S -- sh -c 'passwd -l ubuntu && shutdown -P now'"     # para bloquear usuario "ubuntu" antes de salir. Más recomendable

  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout  = "20m"

  net_device     = "virtio-net"
  disk_interface = "virtio"
  boot_wait      = "6s"
}


build {
  name = "ubuntu-stage2"
  sources = [
    "source.qemu.stage2"
  ]

  ### Ejemplo de provisioner a personalizar (:
  provisioner "shell" {
    env = {
      DEBIAN_FRONTEND = "noninteractive"
    }
    execute_command = "echo '${var.ssh_password}' | sudo -S bash -c '{{ .Vars }} {{ .Path }}'"
    inline = [
      "sudo apt update",
      "sudo apt install nginx -y",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
      "sudo ufw allow proto tcp from any to any port 22,80,443",
      "echo 'y' |sudo ufw enable"
    ]
  }

  # Ejecutar paquete de contextualización de OpenNebula
  provisioner "shell" {
    env = {
      DEBIAN_FRONTEND = "noninteractive",
    }
    execute_command = "echo '${var.ssh_password}' | sudo -S bash -c '{{ .Vars }} {{ .Path }}'"
    script          = "install_onecontext.sh"
  }

  post-processor "compress" {
    # output = "${var.vm_name}-${legacy_isotime("2006-01-02-15-04-05")}.qcow2.gz"
    output = "${var.vm_name}.qcow2.gz"
  }
}


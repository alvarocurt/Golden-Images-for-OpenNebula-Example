source "qemu" "stage1" {

  iso_checksum    = "file:http://releases.ubuntu.com/${var.ubuntu_series}/SHA256SUMS"
  iso_target_path = "packer_cache/${var.ubuntu_series}.iso"
  iso_url         = "https://releases.ubuntu.com/${var.ubuntu_series}/${var.ubuntu_iso}"

  vm_name     = "${var.vm_name}-stage1.qcow2"
  format      = "qcow2"
  accelerator = "kvm"   # default
  disk_size   = "5120M" # default 5G  (GiB)
  memory      = 4096    # default 512 (MiB)

  output_directory = "builds"
  headless         = true
  shutdown_command = "echo '${var.ssh_password}' | sudo -S -- sh -c 'shutdown -P now'"

  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout  = "30m"

  http_content = {
    "/meta-data" = file("http/meta-data")
    "/user-data" = templatefile("http/user-data", { var = var })
  }

  net_device     = "virtio-net"
  disk_interface = "virtio"
  boot_wait      = "6s"

  # Abre el grub, borra todo y sobreescribe lo que se ve
  boot_command = [
    "<esc><esc><esc><esc>e<wait>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del>",
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\"<enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter>",
    "<enter><f10><wait>",
  ]
}

## Para renombrar Imagen output
build {
  name    = "ubuntu-stage1"
  sources = ["source.qemu.stage1"]

  post-processor "shell-local" {
    inline = [
      "export IMAGE_NAME=${var.vm_name}-stage1.qcow2",
      "mv builds/$IMAGE_NAME $IMAGE_NAME",
      "rmdir builds"
    ]
    inline_shebang = "/bin/bash -e"
  }
}
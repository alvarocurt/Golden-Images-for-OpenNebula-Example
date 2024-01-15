#!/bin/bash -e

# Descargar última versión desde https://github.com/OpenNebula/addon-context-linux/releases
# para estos OS https://docs.opennebula.io/6.8/management_and_operations/references/kvm_contextualization.html#kvm-contextualization
wget -P /tmp https://github.com/OpenNebula/addon-context-linux/releases/download/v6.6.1/one-context_6.6.1-1.deb

apt purge -y cloud-init
# si quisiera usar cloud-init, resetear configuración con
#cloud-init clean -s -l

#dpkg -i /tmp/one-context_*deb || apt-get install -fy
apt install --yes /tmp/one-context_6.6.1-1.deb
rm /tmp/one-context_*deb

# Borrar identificadores únicos de la VM. Últimos pasos antes de zanjarla como Golden Image
rm -f /etc/machine-id /var/lib/dbus/machine-id
rm /etc/ssh/ssh_host_*
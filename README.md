# Ejemplo de creación de Imagen Golden ubuntu de servidor Nginx para OpenNebula

Se divide la creación en dos fases diferenciadas:
1. Stage 1: Instalación del OS en la VM a partir de una ISO: Configuración de la instalación mediante el fichero [autoinstall]([url](https://ubuntu.com/server/docs/install/autoinstall-reference)) en http/user_data
2. Stage 2: Provisión de configuración final de la VM: Scripts a ejecutar y por último, paquete de contextualización de OpenNebula.

Tras instalar el paquete de contextualización de OpenNebula, packer no es capaz de volver a entrar a configurar la VM ([cloud-init]([url](https://cloudinit.readthedocs.io/en/latest/reference/network-config.html))) luego este paso solamente debe realizarse en el último stage de la imagen golden.

Las variables de los ficheros junto a sus valores default están declaradas en `variables.pkr.hcl`, pero para darles valores alternativos editar el fichero `custom.auto.pkvars.hcl`

Los comandos a realizar para crear imágenes son:
```bash
packer validate .   # Opcional, comprueba que la configuración es correcta
packer init .       # Descarga plugin de QEMU
# añadir envvar PACKER_LOG=1 para añadir verbosidad en ejecución
packer build -var-file=custom.auto.pkrvars.hcl -only='ubuntu-stage1.qemu.stage1' .
packer build -var-file=custom.auto.pkrvars.hcl -only='ubuntu-stage2.qemu.stage2' .
```

Puedo debuguear los pasos que va haciendo Packer en tiempo real en la VM conectandome al servidor VNC que lanza en local. Si packer se está ejecutando en un host remoto, abro túnel local al puerto VNC con:
```bash
ssh -L 5900:localhost:59xx discovery-one-11
```
Siendo 59xx el puerto que diga el output de Packer.
Desde un cliente VNC (como VNC Viewer) me conecto al server con `localhost:5900`

## Subir imagen a OpenNebula
Para que la imágen esté disponible en nuestros entornos, hay principalmente [dos opciones](https://docs.opennebula.io/6.6/management_and_operations/storage_management/images.html#creating-images):
- Subirla a un [marketplace](https://docs.opennebula.io/6.6/marketplace/index.html#marketplaces) y descargarla de ahí en nuestros datastores
- Subir la imagen desde el frontend.
```bash
# Guardar imagen a subir en directorio seguro para el datastore. One es capaz de procesar imagenes con compresión gzip
scp discovery-one-11:/opt/packer/ubuntu-nginx/ubuntu-nginx-2024-01-10-17-52-29.qcow2.gz  /var/tmp/

oneimage create --datastore 101 --name Ubuntu-Nginx-Packer --path /var/tmp/ubuntu-nginx-2024-01-10-17-52-29.qcow2.gz --prefix vd --description "Unmutable ubuntu-nginx made with Packer"
# vd para decir que la imagen se monta sobre dispositivo virtio

##### También es posible subir la imágen metiendo los parámetros en un fichero plantilla
oneimage create ubuntu_img.one --datastore 101
# Siendo la plantilla:
cat ubuntu_img.one
NAME          = "Ubuntu-Nginx-Packer"
DESCRIPTION   = "Unmutable ubuntu-nginx made with Packer"
PATH          = "/var/tmp/ubuntu-nginx-2024-01-10-17-52-29.qcow2.gz"
DEV_PREFIX    = "vd"
```

## Inspiraciones

- https://github.com/dklischies/Packer-Ghidra-Server-OpenNebula/tree/master
- https://github.com/canonical/packer-maas/tree/15cd61d6e5c098171e472deacbee6915c9b92fca/ubuntu
- https://github.com/tylert/packer-build/tree/master/source



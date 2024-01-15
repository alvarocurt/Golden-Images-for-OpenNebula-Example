# Ejemplo de creación de Imagen Golden ubuntu de servidor Nginx para OpenNebula

Se divide la creación en dos fases diferenciadas:
1. Stage 1: Instalación del OS en la VM a partir de una ISO: Configuración de la instalación mediante el fichero autoinstall en http/user_data
2. Stage 2: Provisión de configuración final de la VM: Scripts a ejecutar y por último, paquete de contextualización de OpenNebula.

Tras instalar el paquete de contextualización de OpenNebula, packer no es capaz de volver a entrar a configurar la VM (cloud init) luego este paso solamente debe realizarse en el último stage de la imagen golden.

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

Inspiraciones:
- https://github.com/dklischies/Packer-Ghidra-Server-OpenNebula/tree/master
- https://github.com/canonical/packer-maas/tree/15cd61d6e5c098171e472deacbee6915c9b92fca/ubuntu
- https://github.com/tylert/packer-build/tree/master/source



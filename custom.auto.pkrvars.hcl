### Todas estas variables están redeclarando los valores default, luego son opcionales

# Releases de ubuntu en http://releases.ubuntu.com/
# Ó daily builds en https://cloud-images.ubuntu.com/ (no he logrado hacerlo con estas)
ubuntu_series = "jammy"

ssh_username = "ubuntu" # no vale root ): ya probé
ssh_password = "ubuntu"
# generar con mkpasswd --method=SHA-512 --stdin
ssh_password_crypted = "$6$canonical.$0zWaW71A9ke9ASsaOcFTdQ2tx1gSmLxMPrsH0rF0Yb.2AEKNPV1lrF94n6YuPJmnUy2K2/JSDtxuiBDey6Lpa/"

vm_name = "nginx-golden"
locale  = "C.UTF-8"    # el que he visto que usan las VMs de OpenNebula, el default es "en_US.UTF-8". El de España es "es_ES.UTF-8"
keyboard_layout   = "us"
keyboard_variant  = ""

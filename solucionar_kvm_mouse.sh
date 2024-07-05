#!/bin/bash

# Actualizar el sistema
echo "Actualizando el sistema..."
sudo apt update && sudo apt upgrade -y

# Verificar y cargar el módulo usbhid
echo "Verificando y cargando el módulo usbhid..."
sudo modprobe usbhid

# Agregar usbhid a la lista de módulos para que se cargue al inicio
if ! grep -q 'usbhid' /etc/modules; then
    echo 'usbhid' | sudo tee -a /etc/modules
    echo "Módulo usbhid agregado a /etc/modules."
else
    echo "El módulo usbhid ya está en /etc/modules."
fi

# Reconfigurar X Server
echo "Reconfigurando X Server..."
sudo dpkg-reconfigure xserver-xorg

# Crear archivo de configuración para el ratón en Xorg
MOUSE_CONF="/etc/X11/xorg.conf.d/90-mouse.conf"
if [ ! -f "$MOUSE_CONF" ]; then
    echo "Creando archivo de configuración del ratón en Xorg..."
    sudo mkdir -p /etc/X11/xorg.conf.d/
    sudo bash -c 'cat << EOF > /etc/X11/xorg.conf.d/90-mouse.conf
Section "InputClass"
    Identifier "Mouse"
    MatchIsPointer "on"
    Driver "libinput"
EndSection
EOF'
    echo "Archivo de configuración del ratón creado en $MOUSE_CONF."
else
    echo "El archivo de configuración del ratón ya existe en $MOUSE_CONF."
fi

# Reiniciar el sistema
echo "Es necesario reiniciar el sistema para aplicar los cambios. ¿Deseas reiniciar ahora? (s/n)"
read RESTART
if [ "$RESTART" = "s" ]; then
    echo "Reiniciando el sistema..."
    sudo reboot
else
    echo "Recuerda reiniciar el sistema más tarde para aplicar los cambios."
fi

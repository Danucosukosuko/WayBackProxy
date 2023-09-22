#!/bin/bash

# Pantalla de inicio
clear
echo "╔════════════════════════╗"
echo "║                        ║"
echo "║ Instalar WayBackProxy  ║"
echo "║                        ║"
echo "╚════════════════════════╝"
echo "Presiona 'I' para continuar..."
read -n 1 input

if [ "$input" != "I" ] && [ "$input" != "i" ]; then
    echo "La tecla presionada no es 'I'. Saliendo..."
    exit 1
fi

# Obtiene la ruta actual
rt=$(pwd)

# Crea un servicio Systemd para Proxy_server.py
service_file="/etc/systemd/system/proxy_server.service"
echo "[Unit]" > "$service_file"
echo "Description=Proxy Server" >> "$service_file"
echo "" >> "$service_file"
echo "[Service]" >> "$service_file"
echo "ExecStart=$rt/proxy_server.py" >> "$service_file"
echo "Restart=always" >> "$service_file"
echo "" >> "$service_file"
echo "[Install]" >> "$service_file"
echo "WantedBy=multi-user.target" >> "$service_file"

# Recarga la configuración de Systemd
sudo systemctl daemon-reload

# Inicia el servicio
sudo systemctl start proxy_server

pip -r requirements.txt

# Limpia la pantalla y muestra el mensaje de instalación correcta
clear
echo "╔══════════════════════════╗"
echo "║                          ║"
echo "║ Instalado correctamente  ║"
echo "║                          ║"
echo "╚══════════════════════════╝"

#!/bin/bash

IMAGE_NAME="ubuntu24-xfce-vnc"
CONTAINER_NAME="ubuntu_gui_container"

# Build de la imatge
echo "Construint la imatge Docker..."
docker build -t $IMAGE_NAME .

# Eliminar contenidor anterior si existeix
echo "Eliminant contenidor anterior (si existeix)..."
docker rm -f $CONTAINER_NAME 2>/dev/null

# Crear i executar contenidor amb ports redirigits
echo "Executant contenidor..."
docker run -d -p 5901:5901 -p 2244:22 --name $CONTAINER_NAME $IMAGE_NAME

echo "Contenidor en execució. Connecta't via VNC a localhost:5901"
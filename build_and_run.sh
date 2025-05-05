#!/bin/bash

# Configuración
IMAGE_NAME="ubuntu24-xfce-vnc"
CONTAINER_NAME="ubuntu_gui"
VNC_PORT=5901
SSH_PORT=2222

# Función de limpieza mejorada
cleanup() {
    echo "🛑 Deteniendo contenedor..."
    docker stop $CONTAINER_NAME >/dev/null 2>&1 || true
    echo "🧹 Eliminando contenedor..."
    docker rm $CONTAINER_NAME >/dev/null 2>&1 || true
}

# 1. Construir imagen
echo "🔨 Construyendo imagen Docker..."
docker build -t $IMAGE_NAME . || {
    echo "❌ Error al construir la imagen"
    exit 1
}

# 2. Limpieza previa
cleanup

# 3. Ejecutar contenedor
echo "🚀 Iniciando contenedor..."
docker run -d \
    -p $VNC_PORT:5901 \
    -p $SSH_PORT:22 \
    --name $CONTAINER_NAME \
    $IMAGE_NAME \
    /bin/bash -c "
    # Configurar VNC
    chown -R docker:docker /home/docker
    su - docker -c 'vncserver :1 -geometry 1280x800 -depth 24'
    
    # Configurar SSH
    service ssh start
    
    # Mantener contenedor activo
    echo '✅ Servicios iniciados: VNC (5901) y SSH (22)'
    tail -f /dev/null
    " || {
    echo "❌ Error al iniciar el contenedor"
    cleanup
    exit 1
}

# 4. Mostrar información
echo -e "\n💻 CONTENEDOR EN EJECUCIÓN"
echo "===================================="
echo "VNC:"
echo "  Host: localhost"
echo "  Puerto: $VNC_PORT"
echo "  Contraseña: docker1234"
echo ""
echo "SSH:"
echo "  Host: localhost"
echo "  Puerto: $SSH_PORT"
echo "  Usuario: docker"
echo "  Contraseña: docker1234"
echo ""
echo "🛑 Para detener: docker stop $CONTAINER_NAME"
echo "===================================="

# 5. Terminar el script y devolver la shell al sistema
echo "🚀 Contenedor iniciado, devolviendo el control a la shell del sistema."
exit 0
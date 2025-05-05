---

### ✅ `build_and_run.sh`

```bash
#!/bin/bash

IMAGE_NAME="ubuntu24-xfce-vnc"
CONTAINER_NAME="ubuntu_gui_container"

# Build de la imatge
docker build -t $IMAGE_NAME .

# Eliminar contenidor anterior (si existeix)
docker rm -f $CONTAINER_NAME 2>/dev/null

# Crear contenidor
docker run -d \
  --name $CONTAINER_NAME \
  -p 5901:5901 \
  -p 2222:22 \
  $IMAGE_NAME
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=docker

# 1. Instalar paquetes esenciales
RUN apt-get update && apt-get install -y \
    sudo \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    wget \
    curl \
    gnupg2 \
    software-properties-common \
    openssh-server \
    python3 \
    python3-pip \
    python3-venv \
    dbus-x11 \
    x11-xserver-utils \
    net-tools \
    git \
    nano \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 2. Instalar VS Code
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
    && install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ \
    && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' \
    && apt-get update \
    && apt-get install -y code \
    && rm microsoft.gpg

# 3. Configurar usuario
RUN useradd -m -s /bin/bash docker \
    && echo "docker:docker1234" | chpasswd \
    && usermod -aG sudo docker \
    && echo "docker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 4. Preparar VNC (sin contraseña en ENV)
USER docker
RUN mkdir -p /home/docker/.vnc \
    && echo "docker1234" | vncpasswd -f > /home/docker/.vnc/passwd \
    && chmod 600 /home/docker/.vnc/passwd \
    && echo "#!/bin/sh\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nexec startxfce4" > /home/docker/.vnc/xstartup \
    && chmod +x /home/docker/.vnc/xstartup

# 5. Configurar SSH
USER root
RUN mkdir -p /run/sshd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

EXPOSE 5901 22
VOLUME ["/home/docker/code"]

CMD ["/bin/bash"]
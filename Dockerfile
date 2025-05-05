FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Actualitza i instal·la paquets bàsics
RUN apt-get update && apt-get install -y \
    sudo xfce4 xfce4-goodies \
    tightvncserver \
    wget curl gnupg2 software-properties-common \
    openssh-server \
    python3 python3-pip \
    dbus-x11 x11-xserver-utils \
    && apt-get clean


# Instal·la VS Code
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
    install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ && \
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' && \
    apt-get update && apt-get install -y code && \
    rm microsoft.gpg

# Crea un usuari per al VNC
RUN useradd -m -s /bin/bash docker && \
    echo "docker:docker" | chpasswd && \
    usermod -aG sudo docker

    USER docker
    WORKDIR /home/docker
    
    # Setup inicial de VNC
    RUN mkdir -p /home/docker/.vnc && \
        echo "docker" | vncpasswd -f > /home/docker/.vnc/passwd && \
        chmod 600 /home/docker/.vnc/passwd
    
    # Fitxer per iniciar XFCE amb VNC
    RUN echo "#!/bin/bash\nstartxfce4 &" > /home/docker/.vnc/xstartup && \
        chmod +x /home/docker/.vnc/xstartup
    
    EXPOSE 5901 22
    
    # Script d'arrencada
    CMD ["/bin/bash", "-c", "vncserver :1 -geometry 1280x800 -depth 24 && tail -F /home/docker/.vnc/*.log"]
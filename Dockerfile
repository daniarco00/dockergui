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
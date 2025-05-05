# Entorn Gràfic Ubuntu 24.04 amb XFCE, VNC, VS Code i SSH

Aquest repositori conté la configuració Docker per crear un entorn gràfic Ubuntu 24.04 amb:
- Escriptori XFCE
- Servidor VNC
- Visual Studio Code
- Python 3
- Servidor SSH

## Requisits previs

- Docker instal·lat
- Client VNC (Recomanat: Remmina)
- Client SSH (opcional)

## Contingut del repositori
- Dockerfile - Configuració de la imatge Docker
- build_and_run.sh - Script per construir i executar el contenidor
- README.md - Aquest arxiu


## Configuració bàsica

| Element       | Valor        |
|---------------|--------------|
| **Usuari**    | `docker`     |
| **Contrasenya**| `docker1234` |
| **Port VNC**  | `5901`       |
| **Port SSH**  | `2222`       |

## Instruccions d'ús

### 1. Construir la imatge i executar el contenidor

```bash
# Donar permisos d'execució al script
chmod +x build_and_run.sh

# Executar el script (construirà i llançarà el contenidor)
./build_and_run.sh


Estructura del Dockerfile
Base: Ubuntu 24.04

Escriptori: XFCE

Servidor VNC: TightVNC

Editor: Visual Studio Code

Llenguatge: Python 3

Accés remot: OpenSSH Server

Notes addicionals
El contenidor està configurat per persistir fins que s'aturi manualment

Tots els serveis s'inicien automàticament

L'accés SSH està configurat amb autenticació per contrasenya
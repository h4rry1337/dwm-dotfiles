#!/bin/bash

set -e

LOGFILE="$HOME/dwm_install.log"

exec > >(tee -a "$LOGFILE") 2>&1

echo "=============================="
echo "[+] Iniciando instalação DWM"
echo "Data: $(date)"
echo "=============================="

echo "[+] Instalando dependências..."
sudo pacman -S --needed --noconfirm \
    feh unzip base-devel libx11 libxft libxinerama \
    xclip flameshot

echo "[+] Extraindo arquivos..."
for file in bkp-*.zip; do
    echo "[+] Processando $file..."

    name=$(basename "$file" .zip)
    clean_name=${name#bkp-}

    unzip -q "$file"

    extracted_dir=$(unzip -Z1 "$file" | head -n1 | cut -d/ -f1)

    rm -rf "$clean_name"
    mv "$extracted_dir" "$clean_name"
done

echo "[+] Detectando diretórios..."
DWM_DIR=$(find . -maxdepth 1 -type d -name "dwm-*" | head -n1)
DMENU_DIR=$(find . -maxdepth 1 -type d -name "dmenu-*" | head -n1)
SLSTATUS_DIR=$(find . -maxdepth 1 -type d -name "slstatus*" | head -n1)

echo "DWM: $DWM_DIR"
echo "DMENU: $DMENU_DIR"
echo "SLSTATUS: $SLSTATUS_DIR"

echo "[+] Compilando e instalando..."

for dir in "$DWM_DIR" "$DMENU_DIR" "$SLSTATUS_DIR"; do
    if [ -d "$dir" ]; then
        echo "[+] Instalando $dir..."
        cd "$dir"
        sudo make clean install
        cd ..
    else
        echo "[!] Diretório não encontrado: $dir"
    fi
done

echo "[+] Instalando startdwm.sh..."
sudo mv startdwm.sh /usr/local/bin/startdwm.sh
sudo chmod 755 /usr/local/bin/startdwm.sh

echo "[+] Copiando wallpapers..."
cp -r .wallpapers ~/.wallpapers

echo "=============================="
echo "[✓] Instalação concluída!"
echo "Log: $LOGFILE"
echo "=============================="

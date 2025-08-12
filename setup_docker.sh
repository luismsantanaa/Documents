#!/bin/bash
set -e

# === Detectar disco externo automáticamente ===
echo "=== Detectando disco externo ==="
EXTERNO=$(lsblk -dno NAME,SIZE,TYPE | grep disk | awk '$2+0 > 100 {print $1}' | grep -v $(lsblk -no NAME,TYPE | grep part | head -n1 | cut -d' ' -f1) | head -n1)

if [ -z "$EXTERNO" ]; then
    echo "❌ No se encontró disco externo válido."
    exit 1
fi

DISCO="/dev/$EXTERNO"
PARTICION="${DISCO}1"
MONTAJE="/mnt/docker_data"

echo "Usando disco externo: $DISCO"

# === Actualizar sistema ===
echo "=== Actualizando sistema ==="
sudo apt update && sudo apt upgrade -y

# === Instalar utilidades necesarias ===
echo "=== Instalando utilidades ==="
sudo apt install -y parted ca-certificates curl gnupg lsb-release zram-tools

# === Preparar disco externo ===
echo "=== Preparando disco externo ==="
sudo umount $DISCO || true
sudo parted $DISCO mklabel gpt -s
sudo parted -a opt $DISCO mkpart primary ext4 0% 100%
sudo mkfs.ext4 -L docker_data $PARTICION

# === Crear punto de montaje y añadir a fstab ===
echo "=== Montando disco ==="
sudo mkdir -p $MONTAJE
UUID=$(blkid -s UUID -o value $PARTICION)
grep -q "$UUID" /etc/fstab || echo "UUID=$UUID $MONTAJE ext4 defaults,noatime 0 2" | sudo tee -a /etc/fstab
sudo mount -a

# === Instalar Docker ===
echo "=== Instalando Docker ==="
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# === Mover datos de Docker al disco externo ===
echo "=== Moviendo Docker a disco externo ==="
sudo systemctl stop docker
sudo mv /var/lib/docker $MONTAJE
sudo ln -s $MONTAJE /var/lib/docker
sudo systemctl start docker
sudo systemctl enable docker

# === Activar ZRAM ===
echo "=== Configurando ZRAM ==="
echo "ALGO=lz4" | sudo tee /etc/default/zram-config
echo "ZRAM_PERCENTAGE=50" | sudo tee -a /etc/default/zram-config
sudo systemctl enable --now zram-config

# === Final ===
echo "✅ Configuración completada."
docker --version
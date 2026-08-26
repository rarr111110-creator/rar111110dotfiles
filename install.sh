#!/bin/sh

set -e

echo "==================================================="
echo "  Instalador de Hyprland y Noctalia para Void Linux"
echo "==================================================="

echo ""
echo "[1/7] Configurando repositorios..."

echo "repository=https://repo.voiders.dev" | sudo tee /etc/xbps.d/10-voiders-community.conf > /dev/null

sudo cp /usr/share/xbps.d/00-repository-main.conf /etc/xbps.d/
sudo sed -i "1i repository=https://mirror.black-hole.dev/$(xbps-uhelper arch)" /etc/xbps.d/00-repository-main.conf

echo "Actualizando sistema..."
sudo xbps-install -Syu

echo ""
echo "[2/7] Instalando gestores de sesión..."

sudo xbps-install -y \
    seatd \
    turnstile \
    dbus \
    polkit \
    polkit-gnome

echo ""
echo "[3/7] Instalando Hyprland y dependencias gráficas..."

sudo xbps-install -y \
    hyprland \
    xdg-desktop-portal \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk \
    xorg-server-xwayland \
    qt5-wayland \
    qt6-wayland \
    wayland \
    wayland-protocols \
    mesa \
    mesa-dri \
    libglvnd

echo ""
echo "[4/7] Instalando Noctalia y utilidades..."

sudo xbps-install -y noctalia

sudo xbps-install -y \
    void-repo-nonfree \
    void-repo-multilib \
    void-repo-multilib-nonfree 

sudo xbps-install -y \
    foot \
    dolphin \
    playerctl \
    grim \
    slurp \
    wl-clipboard \
    pipewire \
    wireplumber \
    pamixer \
    brightnessctl \
    wget \
    curl \
    git \
    fastfetch \
    hyprlock \
    linux-firmware \
    hyprland-guiutils \
    pavucontrol \
    rtkit \
    bluez-alsa \
    bluez \
    alsa-pipewire \
    adw-bluetooth \
    NetworkManager \
    fonts-roboto-ttf \
    xtools \
    fontconfig \
    xdg-utils \
    xdg-user-dirs \
    flatpak \
    adwaita-icon-theme \
    gnome-themes-standard \
    qt5ct \
    qt6ct \
    nemo \
    gvfs \
    gvfs-smb \
    gnome-software \
    nautilus \
    mesa \
    mesa-dri \
    unzip
    

     

     echo ""
     echo "Instalando fuentes Roboto Mono y Roboto Flex..."

FONT_DIR="$HOME/.local/share/fonts/roboto-mono"
RAW_TTF_URL="https://github.com/google/fonts/raw/main/apache/robotoMono/RobotoMono[wght].ttf"
ZIP_URL="https://github.com/google/fonts/releases/download/v2.001/roboto-mono-v2.001.zip"
TMP_FILE="/tmp/roboto-mono-download"
EXTRACT_DIR="/tmp/roboto-mono-extract"

mkdir -p "$FONT_DIR"

cleanup() {
  rm -f "$TMP_FILE"
  rm -rf "$EXTRACT_DIR"
}
trap cleanup EXIT

download() {
  url="$1"
  if command -v curl >/dev/null 2>&1; then
    curl -L -s -o "$TMP_FILE" "$url"
    return $?
  elif command -v wget >/dev/null 2>&1; then
    wget -q -O "$TMP_FILE" "$url"
    return $?
  else
    return 2
  fi
}

if download "$RAW_TTF_URL" && [ -s "$TMP_FILE" ]; then
  if command -v file >/dev/null 2>&1 && file "$TMP_FILE" | grep -iq "TrueType"; then
    mv -f "$TMP_FILE" "$FONT_DIR/RobotoMono.ttf"
    echo "Roboto Mono instalada correctamente (TTF directo)."
    exit 0 || true
  fi
fi

if download "$ZIP_URL" && [ -s "$TMP_FILE" ]; then
  if command -v unzip >/dev/null 2>&1 && unzip -t "$TMP_FILE" >/dev/null 2>&1; then
    rm -rf "$EXTRACT_DIR"
    unzip -q -o "$TMP_FILE" -d "$EXTRACT_DIR"
    find "$EXTRACT_DIR" -type f -iname '*.ttf' -exec cp -n {} "$FONT_DIR/" \;
    echo "Roboto Mono instalada correctamente (desde ZIP)."
    exit 0 || true
  fi
fi

echo "Advertencia: No se pudo descargar Roboto Mono directamente. Intentando con paquete fonts-roboto-ttf..."
if command -v xbps-install >/dev/null 2>&1; then
  sudo xbps-install -y fonts-roboto-ttf 2>/dev/null || true
fi

echo "Fuentes instaladas (o se intentó instalar paquete)."
    



echo ""
echo "[5/7] Habilitando servicios..."

sudo ln -sf /etc/sv/dbus /var/service/
sudo ln -sf /etc/sv/seatd /var/service/
sudo ln -sf /etc/sv/turnstiled /var/service/
sudo ln -sf /etc/sv/bluetoothd /var/service/
sudo ln -sf /etc/sv/NetworkManager /var/service/
sudo ln -sf /etc/sv/elogind /var/service/
sudo ln -sf /etc/sv/chronyd /var/service/

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"




sudo usermod -aG _seatd "$(whoami)"
sudo usermod -aG video "$(whoami)"
sudo usermod -aG audio "$(whoami)"

echo ""
echo "[6/7] Configurando variables de entorno..."

mkdir -p ~/.config/environment.d

cat > ~/.config/environment.d/hyprland.conf << 'EOF'
MOZ_ENABLE_WAYLAND=1
EOF

echo ""
echo "[7/7] Configurando Hyprland..."

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
chmod +x "${SCRIPT_DIR}/configure-hyprland.sh"
bash "${SCRIPT_DIR}/configure-hyprland.sh"


echo ""
echo "==================================================="
echo "  ¡Instalación completada!"
echo "==================================================="
echo ""
echo "PRÓXIMOS PASOS:"
echo ""
echo "1. CERRAR SESIÓN COMPLETAMENTE y volver a entrar"
echo ""
echo "2. Iniciar Hyprland desde TTY:"
echo "   start-hyprland"
echo ""
echo "Si Noctalia no inicia, prueba:"
echo "   sudo xbps-install sdbus-c++"
echo ""

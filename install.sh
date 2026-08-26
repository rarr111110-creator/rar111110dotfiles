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
    mesa-dri
    

     

     echo ""
     echo "Instalando fuentes "

git clone --depth 1 --no-checkout https://github.com/google/fonts.git /tmp/google-fonts

# copiar solo los subdirectorios que necesitas
if [ -d /tmp/google-fonts/apache/robotomono ]; then
    find /tmp/google-fonts/apache/robotomono -type f -iname '*.ttf' -exec cp -n {} "$HOME/.local/share/fonts/roboto-mono/" \;
else
    echo "ERROR: No se encontró Roboto Mono"
    exit 1
fi

if [ -d /tmp/google-fonts/ofl/robotoflex ]; then
    find /tmp/google-fonts/ofl/robotoflex -type f -iname '*.ttf' -exec cp -n {} "$HOME/.local/share/fonts/roboto-flex/" \;
else
    echo "ERROR: No se encontró Roboto Flex"
    exit 1
fi

# opcional limpiar
rm -rf /tmp/google-fonts



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

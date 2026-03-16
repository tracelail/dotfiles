#!/bin/bash
set -e

echo "==> Installing dependencies..."
sudo apt install -y git conky-all jq curl sassc gtk2-engines-murrine

echo "==> Creating directories..."
mkdir -p ~/.config/conky
mkdir -p ~/.themes
mkdir -p ~/.local/share/fonts
mkdir -p ~/.config/autostart

echo "==> Installing Conky Mimosa theme..."
cp -r configs/conky/Mimosa ~/.config/conky/

echo "==> Installing fonts..."
cp configs/conky/Mimosa/fonts/*.ttf ~/.local/share/fonts/
sudo fc-cache -fv

echo "==> Installing Orchis-Dark GTK theme..."
cp -r configs/themes/Orchis-Dark ~/.local/share/themes/

echo "==> Installing Tela icon theme..."
git clone https://github.com/vinceliuice/Tela-icon-theme.git /tmp/Tela-icon-theme
cd /tmp/Tela-icon-theme && ./install.sh
cd -

echo "==> Setting up Conky autostart..."
cat > ~/.config/autostart/conky.desktop << 'DESKTOP'
[Desktop Entry]
Type=Application
Name=Conky
Exec=bash -c "sleep 10 && cd ~/.config/conky/Mimosa && bash start.sh"
StartupNotify=false
Terminal=false
DESKTOP

echo ""
echo "==> Done! A few manual steps remaining:"
echo "    1. Open System Settings -> Themes and set Orchis-Dark"
echo "    2. Set Tela icon theme"
echo "    3. Edit ~/.config/conky/Mimosa/scripts/weather-v4.0.sh"
echo "       and add your OpenWeatherMap API key and city ID"
echo "    4. Run: cd ~/.config/conky/Mimosa && bash start.sh"

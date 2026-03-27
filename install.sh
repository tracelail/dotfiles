#!/bin/bash
set -e

# ─── Packages ────────────────────────────────────────────────────────

echo "==> Installing packages..."
sudo apt update
xargs sudo apt install -y < packages.txt

echo "==> Creating directories..."
mkdir -p ~/.config/conky
mkdir -p ~/.local/share/themes
mkdir -p ~/.local/share/fonts
mkdir -p ~/.config/autostart


# ─── Zsh + Oh My Zsh + Powerlevel9k ────────────────────────────────
# Docs: https://ohmyz.sh/#install
# Theme: https://github.com/Powerlevel9k/powerlevel9k#installation
# Fonts: https://powerline.readthedocs.io/en/latest/installation/linux.html#fonts-installation

echo "==> Installing Oh My Zsh..."
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended

echo "==> Setting zsh as default shell..."
chsh -s $(which zsh)

echo "==> Installing Powerlevel9k theme..."
git clone --recursive https://github.com/Powerlevel9k/powerlevel9k.git $HOME/powerlevel9k

echo "==> Installing Powerline fonts..."
git clone https://github.com/powerline/fonts.git --depth=1 /tmp/powerline-fonts
cd /tmp/powerline-fonts && ./install.sh
cd ~ && rm -rf /tmp/powerline-fonts

echo "==> Copying zsh config..."
cp configs/zsh/.zshrc ~/.zshrc

echo ""
echo "    MANUAL STEP: Configure terminal font"
echo "    Go to Preferences -> Profile -> Text tab"
echo "    Uncheck 'Use the system fixed width font'"
echo "    Choose a Powerline font e.g. 'DejaVu Sans Mono for Powerline'"
echo "    Then restart your terminal."


# ─── Orchis-Dark GTK Theme + Tela Icons ─────────────────────────────
# Docs: https://www.gnome-look.org/p/1357889
# Icons: https://github.com/vinceliuice/Tela-icon-theme

echo "==> Installing Orchis-Dark GTK theme..."
cp -r configs/themes/Orchis-Dark ~/.local/share/themes/

echo "==> Installing Tela icon theme..."
git clone https://github.com/vinceliuice/Tela-icon-theme.git /tmp/Tela-icon-theme
cd /tmp/Tela-icon-theme && ./install.sh
cd ~ && rm -rf /tmp/Tela-icon-theme

echo ""
echo "    MANUAL STEP: Apply themes in Cinnamon"
echo "    Open System Settings -> Themes"
echo "    Set Applications -> Orchis-Dark"
echo "    Set Desktop    -> Orchis-Dark"
echo "    Set Icons      -> Tela"


# ─── Conky: Mimosa Verdant Theme ─────────────────────────────────────
# Theme: https://www.gnome-look.org/p/1869486
# Install guide: https://malformed-blog.blogspot.com/2025/02/how-to-apply-theme.html

echo "==> Installing Conky Mimosa theme..."
cp -r configs/conky/Mimosa ~/.config/conky/

echo "==> Installing Conky fonts..."
cp configs/conky/Mimosa/fonts/*.ttf ~/.local/share/fonts/
sudo fc-cache -fv

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
echo "    MANUAL STEP: Configure Conky weather + network"
echo "    See README.md for full instructions"
echo ""
echo "==> All done! Please log out and back in for zsh to take effect."

# ─── Redshift ────────────────────────────────────────────────────────
# Blue light filter for night time use

echo "==> Installing Redshift config..."
cp configs/redshift/redshift.conf ~/.config/redshift.conf

echo ""
echo "    MANUAL STEP: Launch Redshift from application menu"
echo "    or run: redshift-gtk &"

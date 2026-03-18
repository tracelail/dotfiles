# Dotfiles

My Linux desktop configuration for Debian 12 (Cinnamon).

## What's included
- **Shell**: Zsh + Oh My Zsh + Powerlevel9k theme + Powerline fonts
- **Conky**: Mimosa Verdant theme (weather, system stats, network)
- **GTK Theme**: Orchis-Dark
- **Icons**: Tela
- **Neofetch**: System info tool

---

## Install on a new machine

```bash
git clone https://github.com/tracelail/dotfiles.git
cd dotfiles
```

### Full install
```bash
make all
```

### Or install individual components
```bash
make packages   # apt packages only
make zsh        # Zsh + Oh My Zsh + Powerlevel9k
make themes     # Orchis-Dark + Tela icons
make conky      # Mimosa Conky theme
```

### See all available commands
```bash
make help
```

> **Note:** `install.sh` is also available if you prefer plain bash over make.

---

## Post-install: Required Manual Steps

### 1. Terminal Font (Zsh / Powerlevel9k)

Powerline fonts are installed automatically but you need to select one in your terminal:

- Open Terminal → **Preferences** → select your profile → **Text** tab
- Uncheck **"Use the system fixed width font"**
- Choose a Powerline font e.g. `DejaVu Sans Mono for Powerline`
- Restart your terminal

**References:**
- https://ohmyz.sh/#install
- https://github.com/Powerlevel9k/powerlevel9k#installation
- https://powerline.readthedocs.io/en/latest/installation/linux.html#fonts-installation

---

### 2. OpenWeatherMap API Key & City ID

The Conky weather widget requires a free OpenWeatherMap account.

**Reference:** https://malformed-blog.blogspot.com/2025/02/how-to-apply-theme.html

**Steps:**
1. Go to https://openweathermap.org and create a free account
2. Verify your email
3. Go to your profile → **My API Keys** and copy your key
4. **Important:** New API keys take a few hours to activate after account creation
5. Find your city ID by going to https://old.openweathermap.org (the new site no longer shows IDs in the URL)
   - Search for your city → click on it
   - Copy the number at the end of the URL: `https://old.openweathermap.org/city/XXXXXXX`
6. Edit the weather script:
```bash
nano ~/.config/conky/Mimosa/scripts/weather-v4.0.sh
```
   Set these two values:
```bash
city_id=YOUR_CITY_ID
api_key=YOUR_API_KEY
```
   Or use sed:
```bash
sed -i 's/city_id=.*/city_id=YOUR_CITY_ID/' ~/.config/conky/Mimosa/scripts/weather-v4.0.sh
sed -i 's/api_key=.*/api_key=YOUR_API_KEY/' ~/.config/conky/Mimosa/scripts/weather-v4.0.sh
```
7. If weather still shows the wrong city after restarting Conky, clear the cache:
```bash
rm ~/.cache/weather.json
```

---

### 3. Network Interface

The network widget needs your actual interface name. Find it with:
```bash
ip link
```
Look for the interface showing `state UP` — it will be something like `wlp2s0` or `eth0`.

Then update the Conky config:
```bash
sed -i 's/wlp9s0/YOUR_INTERFACE_NAME/g' ~/.config/conky/Mimosa/Mimosa.conf
```

---

### 4. Theme Activation (Cinnamon)

After install, apply the themes manually:
- Open **System Settings → Themes**
- Set **Applications** → `Orchis-Dark`
- Set **Desktop** → `Orchis-Dark`
- Set **Icons** → `Tela`

---

### 5. Start Conky
```bash
cd ~/.config/conky/Mimosa && bash start.sh
```

Conky is set to autostart on login via `~/.config/autostart/conky.desktop` with a 10 second delay to allow the desktop to load first.

---

## Repo Structure

```
dotfiles/
├── Makefile                  # Run make help to see all commands
├── install.sh                # Alternative plain bash installer
├── packages.txt              # apt packages list
├── configs/
│   ├── zsh/
│   │   └── .zshrc            # Zsh config with Powerlevel9k
│   ├── conky/
│   │   └── Mimosa/           # Mimosa Verdant Conky theme
│   └── themes/
│       └── Orchis-Dark/      # GTK theme
└── README.md
```

---

## Theme Sources & Credits

| Component | Source |
|-----------|--------|
| Zsh | https://ohmyz.sh |
| Powerlevel9k | https://github.com/Powerlevel9k/powerlevel9k |
| Powerline Fonts | https://powerline.readthedocs.io/en/latest/installation/linux.html#fonts-installation |
| Conky Mimosa Verdant | https://www.gnome-look.org/p/1869486 — by closebox73 |
| Conky install guide | https://malformed-blog.blogspot.com/2025/02/how-to-apply-theme.html |
| Orchis-Dark GTK | https://www.gnome-look.org/p/1357889 — by vinceliuice |
| Tela Icons | https://github.com/vinceliuice/Tela-icon-theme — by vinceliuice |
| Neofetch | https://github.com/dylanaraps/neofetch |

---

## Troubleshooting

**Powerlevel9k prompt not rendering correctly**
Make sure your terminal font is set to a Powerline font. See Manual Step 1 above.

**Black background behind Conky widgets**
Edit `~/.config/conky/Mimosa/Mimosa.conf` and ensure:
```
own_window_argb_visual = false,
```

**Weather showing wrong city**
Clear the cache and restart:
```bash
rm ~/.cache/weather.json && killall conky && cd ~/.config/conky/Mimosa && bash start.sh
```

**Conky icons showing as empty squares**
Fonts aren't installed or cache needs refresh:
```bash
cp ~/.config/conky/Mimosa/fonts/*.ttf ~/.local/share/fonts/
sudo fc-cache -fv
```

**Conky not moving to correct position**
For `bottom_left` alignment, `gap_y` measures from the bottom edge.
Lower number = closer to the taskbar. Negative values push it below.
```bash
grep "gap_y\|alignment" ~/.config/conky/Mimosa/Mimosa.conf
```

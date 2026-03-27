.PHONY: all packages zsh themes conky help

all: packages zsh themes conky redshift ## Run full install

help:  ## Show available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36mmake %-10s\033[0m %s\n", $$1, $$2}'

packages:  ## Install all apt packages from packages.txt
	sudo apt update
	xargs sudo apt install -y < packages.txt

zsh:  ## Install Oh My Zsh + Powerlevel9k + Powerline fonts
	sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended
	chsh -s $(shell which zsh)
	git clone --recursive https://github.com/Powerlevel9k/powerlevel9k.git $$HOME/powerlevel9k
	git clone https://github.com/powerline/fonts.git --depth=1 /tmp/powerline-fonts
	cd /tmp/powerline-fonts && ./install.sh
	cd ~ && rm -rf /tmp/powerline-fonts
	cp configs/zsh/.zshrc ~/.zshrc
	@echo ""
	@echo "MANUAL: Set terminal font to a Powerline font"
	@echo "        Preferences -> Profile -> Text -> uncheck system font"
	@echo "        Choose e.g. 'DejaVu Sans Mono for Powerline'"

themes:  ## Install Orchis-Dark GTK theme + Tela icons
	mkdir -p ~/.local/share/themes
	cp -r configs/themes/Orchis-Dark ~/.local/share/themes/
	git clone https://github.com/vinceliuice/Tela-icon-theme.git /tmp/Tela-icon-theme
	cd /tmp/Tela-icon-theme && ./install.sh
	cd ~ && rm -rf /tmp/Tela-icon-theme
	@echo ""
	@echo "MANUAL: Apply in System Settings -> Themes"
	@echo "        Applications + Desktop -> Orchis-Dark"
	@echo "        Icons -> Tela"

conky:  ## Install Mimosa Conky theme + autostart
	mkdir -p ~/.config/conky ~/.local/share/fonts ~/.config/autostart
	cp -r configs/conky/Mimosa ~/.config/conky/
	cp configs/conky/Mimosa/fonts/*.ttf ~/.local/share/fonts/
	sudo fc-cache -fv
	@printf '[Desktop Entry]\nType=Application\nName=Conky\nExec=bash -c "sleep 10 && cd ~/.config/conky/Mimosa && bash start.sh"\nStartupNotify=false\nTerminal=false\n' > ~/.config/autostart/conky.desktop
	@echo ""
	@echo "MANUAL: See README.md to configure weather API key and network interface"

redshift:  ## Install Redshift night light config
	cp configs/redshift/redshift.conf ~/.config/redshift.conf
	@echo "MANUAL: Launch redshift-gtk from application menu"
#!/usr/bin/env bash

DIR=$(pwd)
PACMAN_CONF_PATH="/etc/pacman.conf"
YAY_PATH=/opt/yay

pacman_enable_setting() {
  local setting="$1"

  # Check if the setting exists and is commented out
  if grep -Eq "^\s*#\s*$setting" "$PACMAN_CONF_PATH"; then
    # Uncomment the setting
    sudo sed -i "s/^\s*#\s*$setting/$setting/" "$PACMAN_CONF_PATH"
    echo "$setting was commented. It has been enabled."
  elif ! grep -Eq "^\s*$setting" "$PACMAN_CONF_PATH"; then
    # If the setting doesn't exist, add it
    echo "$setting" | sudo tee -a "$PACMAN_CONF_PATH" >/dev/null
    echo "$setting was not present. It has been added."
  else
    echo "$setting is already enabled."
  fi
}

pacman_set_parallel_downloads() {
  local expected_value="$1"

  if grep -Eq "^\s*ParallelDownloads" "$PACMAN_CONF_PATH"; then
    # If ParallelDownloads exists, modify it
    sudo sed -i "s/^\s*ParallelDownloads.*/ParallelDownloads = $expected_value/" "$PACMAN_CONF_PATH"
    echo "ParallelDownloads has been set to $expected_value."
  else
    # If ParallelDownloads doesn't exist, add it
    echo "ParallelDownloads = $expected_value" | sudo tee -a "$PACMAN_CONF_PATH" >/dev/null
    echo "ParallelDownloads was not present. It has been added and set to $expected_value."
  fi
}

pacman_install_packages() {
  local pkg=(
    "alacritty"
    "ansible"
    "base-devel"
    "bash-completion"
    "bat"
    "blueman"
    "bluez"
    "bluez-utils"
    "breeze"
    "breeze-icons"
    "brightnessctl"
    "btop"
    "cliphist"
    "curl"
    "dunst"
    "eza"
    "fastfetch"
    "fd"
    "figlet"
    "firefox"
    "flatpak"
    "fuse2"
    "fzf"
    "git"
    "git-delta"
    "github-cli"
    "gnome-calculator"
    "go"
    "grim"
    "gtk4"
    "gum"
    "guvcview"
    "gvfs"
    "htop"
    "hypridle"
    "hyprland"
    "hyprlock"
    "hyprpaper"
    "imagemagick"
    "jq"
    "lazygit"
    "libadwaita"
    "man-pages"
    "mpv"
    "nano"
    "neovim"
    "network-manager-applet"
    "networkmanager"
    "nm-connection-editor"
    "noto-fonts"
    "npm"
    "nwg-look"
    "otf-font-awesome"
    "pacman-contrib"
    "papirus-icon-theme"
    "pavucontrol"
    "pinta"
    "polkit-gnome"
    "python"
    "python-gobject"
    "python-pip"
    "python-pywal"
    "qt6ct"
    "ripgrep"
    "rofi-wayland"
    "sed"
    "slurp"
    "starship"
    "stow"
    "tar"
    "terraform"
    "tokei"
    "ttf-cascadia-code-nerd"
    "ttf-cascadia-mono-nerd"
    "ttf-fira-code"
    "ttf-fira-sans"
    "ttf-firacode-nerd"
    "ttf-jetbrains-mono"
    "ttf-jetbrains-mono-nerd"
    "ttf-meslo-nerd"
    "tumbler"
    "unzip"
    "vim"
    "vlc"
    "waybar"
    "wezterm"
    "wget"
    "xarchiver"
    "xclip"
    "xdg-desktop-portal"
    "xdg-desktop-portal-hyprland"
    "xdg-user-dirs"
    "yq"
    "zip"
    "zoxide"
    "zsh"
    "zsh-completions"
  )

  sudo pacman -S --noconfirm "${pkg[@]}"
}

run_pacman() {
  pacman_enable_setting "Color"
  pacman_enable_setting "VerbosePkgLists"
  pacman_set_parallel_downloads 15
  # https://wiki.archlinux.org/title/Pacman/Package_signing
  sudo pacman-key --init
  sudo pacman-key --populate
  sudo pacman -Sy --needed archlinux-keyring && sudo pacman -Su --noconfirm
  sudo pacman -Sc --noconfirm
  sudo pacman -Rns aws-cli --noconfirm
  pacman_install_packages
}

install_yay() {
  echo "Installing yay..."
  # if [ ! -d "$YAY_PATH" ]; then
  sudo mkdir -p "$YAY_PATH" 2>/dev/null
  # fi
  sudo chown -R "$USER":"$USER" $YAY_PATH
  git clone https://aur.archlinux.org/yay.git $YAY_PATH
  cd $YAY_PATH
  makepkg -si --noconfirm
  yay -Y --gendb --noconfirm && yay -Syu --devel --noconfirm
  echo "Yay has been installed."
  cd $DIR
}

yay_install_packages() {
  local pkg=(
    "aws-cli-v2"
    "aws-sam-cli"
    "aylurs-gtk-shell"
    "bun-bin"
    "grimblast"
    "hyprshade"
    "mission-center"
    "smile"
    "nvm"
    "waypaper"
    "wlogout"
  )

  yay -S --noconfirm "${pkg[@]}"
}

run_yay() {
  install_yay
  yay_install_packages
}

# echo 'source /usr/share/nvm/init-nvm.sh' >> ~/.bashrc
# echo 'source /usr/share/nvm/init-nvm.sh' >> ~/.zshrc

run_pacman
run_yay

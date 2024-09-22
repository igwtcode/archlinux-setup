#!/usr/bin/env bash

# Path to pacman.conf
PACMAN_CONF="/etc/pacman.conf"

# Function to ensure a setting is enabled (uncommented)
enable_setting() {
  local setting="$1"

  # Check if the setting exists and is commented out
  if grep -Eq "^\s*#\s*$setting" "$PACMAN_CONF"; then
    # Uncomment the setting
    sudo sed -i "s/^\s*#\s*$setting/$setting/" "$PACMAN_CONF"
    echo "$setting was commented. It has been enabled."
  elif ! grep -Eq "^\s*$setting" "$PACMAN_CONF"; then
    # If the setting doesn't exist, add it
    echo "$setting" | sudo tee -a "$PACMAN_CONF" >/dev/null
    echo "$setting was not present. It has been added."
  else
    echo "$setting is already enabled."
  fi
}

# Function to ensure ParallelDownloads is set to a specific value
ensure_parallel_downloads() {
  local expected_value="$1"

  if grep -Eq "^\s*ParallelDownloads" "$PACMAN_CONF"; then
    # If ParallelDownloads exists, modify it
    sudo sed -i "s/^\s*ParallelDownloads.*/ParallelDownloads = $expected_value/" "$PACMAN_CONF"
    echo "ParallelDownloads has been set to $expected_value."
  else
    # If ParallelDownloads doesn't exist, add it
    echo "ParallelDownloads = $expected_value" | sudo tee -a "$PACMAN_CONF" >/dev/null
    echo "ParallelDownloads was not present. It has been added and set to $expected_value."
  fi
}

echo "Configuring pacman..."
# Ensure Color and VerbosePkgLists are enabled
enable_setting "Color"
enable_setting "VerbosePkgLists"

# Ensure ParallelDownloads is set to a specific value
ensure_parallel_downloads 15
echo "Pacman has been configured."

# https://wiki.archlinux.org/title/Pacman/Package_signing
sudo pacman-key --init
sudo pacman-key --populate
sudo pacman -Sy --needed archlinux-keyring && sudo pacman -Su --noconfirm
sudo pacman -Sc --noconfirm

#!/bin/bash

# Variables
export DEBIAN_FRONTEND=noninteractive
USER="<your user>"
DOWNLOADS_DIR="/home/${USER}/.downloads"
ZSHRC_DEST="/home/${USER}/.zshrc"
TMUX_DIR="/home/${USER}/.tmux"
TMUX_CONFIG_DIR="/home/${USER}/.tmux.conf"
ANSIBLE_CONFIG_DIR="/home/${USER}/ansible_config"

# Function to copy files and set ownership
copy_files() {
    cp -r "${DOWNLOADS_DIR}/${1}" "${2}"
    chown -R "${USER}:${USER}" "${2}"
}

# Update and install packages
apt update -y
apt upgrade -y
apt install mc vim* wget curl tmux zsh* git build-essential jq ufw ansible ca-certificates gnupg -y

# Copy and set ownership for Zshrc
copy_files ".zshrc" "${ZSHRC_DEST}"

# Copy and set ownership for Tmux
tar -xzf "${DOWNLOADS_DIR}/tmux.tar.gz" -C "${DOWNLOADS_DIR}"
copy_files "tmux/.tmux" "${TMUX_DIR}"
copy_files "tmux/.tmux.conf" "${TMUX_CONFIG_DIR}"

# Copy and set ownership for Ansible config
tar -xzf "${DOWNLOADS_DIR}/ansible_config.tar.gz" -C "${DOWNLOADS_DIR}"
copy_files "ansible_config" "${ANSIBLE_CONFIG_DIR}"

# Set Zsh as default shell
chsh -s /bin/zsh "${USER}"
chsh -s /bin/zsh root

# Docker install
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
yes | echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update -y
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Configure Docker
usermod -aG docker "${USER}"

# Enable Docker services
systemctl enable docker.service
systemctl enable containerd.service

# Reboot
reboot now





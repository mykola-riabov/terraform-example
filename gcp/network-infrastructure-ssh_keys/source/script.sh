#!/bin/bash

# Set user and directories
USER="<your user>"
DOWNLOADS_DIR="/home/${USER}/.downloads"
USER_DIR="/home/${USER}"

# Update and install packages
export DEBIAN_FRONTEND=noninteractive
apt update -y
apt upgrade -y
apt install mc vim* wget curl tmux zsh* git build-essential jq snapd ufw ansible ca-certificates gnupg -y

# Function to copy files and set ownership
copy_files() {
    cp "${DOWNLOADS_DIR}/${1}" "${2}"
    chown -R "${USER}:${USER}" "${2}"
}

# Copy and set ownership for Zshrc
copy_files ".zshrc" "${USER_DIR}/.zshrc"
cp "${USER_DIR}/.zshrc" /root/.zshrc

# Set Zsh as default shell
chsh -s /bin/zsh "${USER}"
chsh -s /bin/zsh root

# Extract and set up Tmux and Ansible config
tar -xzf "${DOWNLOADS_DIR}/tmux.tar.gz" -C "${USER_DIR}"
tar -xzf "${DOWNLOADS_DIR}/ansible_config.tar.gz" -C "${USER_DIR}"
copy_files "tmux/.tmux" "${USER_DIR}/.tmux"
copy_files "tmux/.tmux.conf" "${USER_DIR}/.tmux.conf"
copy_files "ansible_config" "${USER_DIR}/ansible_config"

# Docker installation
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update -y
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Configure Docker permissions and enable services
usermod -aG docker "${USER}"
newgrp docker
systemctl enable docker.service
systemctl enable containerd.service

# Reboot
reboot now





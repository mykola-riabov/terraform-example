#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

USER="<your user>"

apt update -y
apt upgrade -y
apt install mc vim* wget curl tmux zsh* git build-essential jq snapd ufw ansible ca-certificates gnupg -y

# Copy zshrc and set permissions
cp "/home/${USER}/.downloads/.zshrc" "/home/${USER}/.zshrc"
chown -R "${USER}:${USER}" "/home/${USER}/.zshrc"
cp "/home/${USER}/.downloads/.zshrc" /root/.zshrc

# Set default shell to zsh
chsh -s /bin/zsh "${USER}"
chsh -s /bin/zsh root

# Extract and set up tmux and ansible config
tar -xzf "/home/${USER}/.downloads/tmux.tar.gz" -C "/home/${USER}"
tar -xzf "/home/${USER}/.downloads/ansible_config.tar.gz" -C "/home/${USER}"
cp -r "/home/${USER}/.downloads/tmux/.tmux" "/home/${USER}/.tmux"
cp -r "/home/${USER}/.downloads/tmux/.tmux.conf" "/home/${USER}/.tmux.conf"
cp -r "/home/${USER}/.downloads/ansible_config" "/home/${USER}/ansible_config"
chown -R "${USER}:${USER}" "/home/${USER}/.tmux" "/home/${USER}/.tmux.conf" "/home/${USER}/ansible_config"

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




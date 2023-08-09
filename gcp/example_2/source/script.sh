#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

USER="<your user>"

apt update -y
apt upgrade -y
apt install mc vim* wget curl tmux zsh* git build-essential jq snapd ufw ansible -y
cp "/home/${USER}/.downloads/.zshrc" "/home/${USER}/.zshrc"
chown -R "${USER}:${USER}" "/home/${USER}/.zshrc"
cp "/home/${USER}/.downloads/.zshrc" /root/.zshrc
chsh -s /bin/zsh "${USER}"
chsh -s /bin/zsh root
tar -xzf "/home/${USER}/.downloads/tmux.tar.gz" -C "/home/${USER}"
tar -xzf "/home/${USER}/.downloads/ansible_config.tar.gz" -C "/home/${USER}"
cp -r "/home/${USER}/.downloads/tmux/.tmux" "/home/${USER}/.tmux"
cp -r "/home/${USER}/.downloads/tmux/.tmux.conf" "/home/${USER}/.tmux.conf"
cp -r "/home/${USER}/.downloads/ansible_config" "/home/${USER}/ansible_config"
chown -R "${USER}:${USER}" "/home/${USER}/.tmux"
chown -R "${USER}:${USER}" "/home/${USER}/.tmux.conf"
chown -R "${USER}:${USER}" "/home/${USER}/ansible_config"
reboot now



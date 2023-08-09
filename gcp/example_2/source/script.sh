#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

apt update -y
apt upgrade -y
apt install mc vim* wget curl tmux zsh* git build-essential jq snapd ufw ansible -y
cp /home/<your user>/.downloads/.zshrc /home/<your user>/.zshrc
chown -R <your user>:<your user> /home/<your user>/.zshrc
cp /home/<your user>/.downloads/.zshrc /root/.zshrc
chsh -s /bin/zsh <your user>
chsh -s /bin/zsh root
tar -xzf /home/<your user>/.downloads/tmux.tar.gz
tar -xzf /home/<your user>/.downloads/ansible_config.tar.gz
cp -r /home/<your user>/.downloads/tmux/.tmux /home/<your user>/.tmux
cp -r /home/<your user>/.downloads/tmux/.tmux.conf /home/<your user>/.tmux.conf
cp -r /home/<your user>/.downloads/ansible_config /home/<your user>/ansible_config
chown -R <your user>:<your user> /home/<your user>/.tmux
chown -R <your user>:<your user> /home/<your user>/.tmux.conf
chown -R <your user>:<your user> /home/<your user>/ansible_config
reboot now


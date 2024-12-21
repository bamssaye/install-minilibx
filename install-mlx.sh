#!/bin/bash

###### install git if not found and minilibx for ubuntu 
if [ "$EUID" -ne 0 ]; then 
    echo "Please run with sudo: sudo $0"
    exit 1
fi
echo "Updating package list..."
apt-get update
echo "Checking and installing git..."
if ! command -v git &> /dev/null; then
    echo "Git not found. Installing git..."
    apt-get install -y git
else
    echo "Git is already installed"
fi
echo "Installing dependencies..."
apt-get install -y gcc make xorg libxext-dev libbsd-dev
echo "Creating temporary directory..."
TMP_DIR=$(mktemp -d)
cd $TMP_DIR
echo "Cloning minilibx repository..."
git clone https://github.com/42Paris/minilibx-linux.git
cd minilibx-linux
echo "Compiling minilibx..."
make
echo "Installing minilibx..."
cp mlx.h /usr/include
cp libmlx.a /usr/lib
cp libmlx_Linux.a /usr/lib
cp man/man3/* /usr/share/man/man3/ 2>/dev/null || true
echo "Cleaning up..."
cd ..
rm -rf $TMP_DIR
echo "Installation complete!"
echo "To compile your projects, use: gcc file.c -lmlx -lXext -lX11"
################## install vscode if not found
if ! command -v code &> /dev/null; then
    echo "Installing dependencies..."
    apt-get install -y wget gpg apt-transport-https
    echo "Adding Microsoft GPG key..."
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    install -D -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/packages.microsoft.gpg
    rm packages.microsoft.gpg
    echo  "Adding VS Code repository..."
    echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
    echo "Updating package list with new repository..."
    apt-get update
    echo  "Installing Visual Studio Code..."
    apt-get install -y code
    echo "Installation complete!"
    echo "You can now launch VS Code by typing 'code' in the terminal or finding it in your applications menu."
else
    echo "vscode is already installed"
fi


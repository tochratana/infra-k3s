#!/bin/bash

# setup.sh — One-shot setup script for Infrac K3s
# Run this once after cloning the repo to install all required tools
# Usage: bash setup.sh

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}=====================================${NC}"
echo -e "${CYAN}   Infrac K3s — Setup Prerequisites  ${NC}"
echo -e "${CYAN}=====================================${NC}"
echo ""

# ─── 1. Update apt ───────────────────────────────────────────────────────────
echo -e "${YELLOW}[1/4] Updating package list...${NC}"
sudo apt update -y

# ─── 2. Install pip3 ─────────────────────────────────────────────────────────
echo -e "${YELLOW}[2/4] Installing pip3...${NC}"
sudo apt install -y python3-pip

# ─── 3. Install Python tools from requirements.txt ───────────────────────────
echo -e "${YELLOW}[3/4] Installing Python tools (ansible, lint, etc.)...${NC}"
pip3 install -r requirements.txt

# ─── 4. Fix PATH for pip-installed binaries ───────────────────────────────────
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
  export PATH=$PATH:~/.local/bin
  echo -e "${GREEN}  → Added ~/.local/bin to PATH${NC}"
fi

# ─── 5. Install just ─────────────────────────────────────────────────────────
echo -e "${YELLOW}[4/4] Installing just (task runner)...${NC}"
if command -v just &> /dev/null; then
  echo -e "${GREEN}  → just is already installed$(NC)"
else
  sudo apt install -y snapd
  sudo snap install just --classic
fi

echo ""
echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN} ✅ Setup complete! You can now run:  ${NC}"
echo -e "${GREEN}    just install                       ${NC}"
echo -e "${GREEN}=====================================${NC}"

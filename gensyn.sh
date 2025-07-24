#!/bin/bash

# Clear screen and display banner at top
clear
echo -e "\033[H"

# Display colorful banner
echo -e "\033[38;5;39m"
cat << "EOF"
    ██████  ██            ███████ ██     ██  █████  ██████  ███    ███
    ██   ██ ██            ██      ██     ██ ██   ██ ██   ██ ████  ████
    ██████  ██      █████ ███████ ██  █  ██ ███████ ██████  ██ ████ ██
    ██   ██ ██                 ██ ██ ███ ██ ██   ██ ██   ██ ██  ██  ██
    ██   ██ ███████       ███████  ███ ███  ██   ██ ██   ██ ██      ██
EOF
echo -e "\n"
echo -ne "\033[38;5;39mB\033[38;5;45my\033[38;5;51m \033[38;5;87mP\033[38;5;129mi\033[38;5;93mz\033[38;5;99m \033[38;5;105m-\033[38;5;111m \033[38;5;117mT\033[38;5;123mG\033[38;5;129m:\033[38;5;135m \033[38;5;141m2\033[38;5;147m0\033[38;5;153m2\033[38;5;159m4\033[0m"
echo -e "\033[0m\n"

BOLD="\e[1m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NC="\e[0m"

SWARM_DIR="$HOME/rl-swarm"
TEMP_DATA_PATH="$SWARM_DIR/modal-login/temp-data"
HOME_DIR="$HOME"

cd $HOME

if [ -f "$SWARM_DIR/swarm.pem" ]; then
    echo -e "${BOLD}${YELLOW}You already have an existing ${GREEN}swarm.pem${YELLOW} file.${NC}\n"
    echo -e "\n${BOLD}${YELLOW}[✓] Using existing swarm.pem...${NC}"
    mv "$SWARM_DIR/swarm.pem" "$HOME_DIR/"
    mv "$TEMP_DATA_PATH/userData.json" "$HOME_DIR/" 2>/dev/null
    mv "$TEMP_DATA_PATH/userApiKey.json" "$HOME_DIR/" 2>/dev/null

    rm -rf "$SWARM_DIR"

    echo -e "${BOLD}${YELLOW}[✓] Cloning fresh repository...${NC}"
    cd $HOME && git clone https://github.com/whalepiz/rl-swarm.git > /dev/null 2>&1

    mv "$HOME_DIR/swarm.pem" rl-swarm/
    mv "$HOME_DIR/userData.json" rl-swarm/modal-login/temp-data/ 2>/dev/null
    mv "$HOME_DIR/userApiKey.json" rl-swarm/modal-login/temp-data/ 2>/dev/null
else
    echo -e "${BOLD}${YELLOW}[✓] No existing swarm.pem found. Cloning repository...${NC}"
    cd $HOME && [ -d rl-swarm ] && rm -rf rl-swarm; git clone https://github.com/loclam94/rl-swarm.git > /dev/null 2>&1
fi

cd rl-swarm || { echo -e "${BOLD}${RED}[✗] Failed to enter rl-swarm directory. Exiting.${NC}"; exit 1; }

# New section: Create and activate virtual environment
echo -e "\n${BOLD}${YELLOW}[✓] Creating Python virtual environment...${NC}"
python3 -m venv .venv || { echo -e "${BOLD}${RED}[✗] Failed to create virtual environment.${NC}"; exit 1; }

echo -e "${BOLD}${YELLOW}[✓] Activating virtual environment...${NC}"
source .venv/bin/activate || { echo -e "${BOLD}${RED}[✗] Failed to activate virtual environment.${NC}"; exit 1; }

# Run main script
echo -e "\n${BOLD}${GREEN}[✓] Starting RL Swarm...${NC}"
./run_rl_swarm.sh || { echo -e "${BOLD}${RED}[✗] Failed to run RL Swarm.${NC}"; exit 1; }

exit 0

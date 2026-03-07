#!/bin/bash

# Colors for UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Function to display header
display_header() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}${BOLD}Tailscale Setup by Shock Manager 🚀"
    echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
    echo ""
}

# Function to check Tailscale status
check_status() {
    if command -v tailscale &> /dev/null; then
        if systemctl is-active --quiet tailscaled; then
            echo -e "Status: ${GREEN}${BOLD}INSTALLED & RUNNING${NC}"
        else
            echo -e "Status: ${YELLOW}${BOLD}INSTALLED (NOT RUNNING)${NC}"
        fi
    else
        echo -e "Status: ${RED}${BOLD}NOT INSTALLED${NC}"
    fi
}

# Function to install Tailscale
install_tailscale() {
    echo -e "\n${BLUE}${BOLD}╔══════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}${BOLD}║          İnstalling Wait A bit           ║${NC}"
    echo -e "${BLUE}${BOLD}╚══════════════════════════════════════════╝${NC}"
    
    echo -e "\n${YELLOW}Step 1: Downloading installer...${NC}"
    if curl -fsSL https://tailscale.com/install.sh | sh; then
        echo -e "${GREEN}✓ Download complete${NC}"
    else
        echo -e "${RED}✗ Download failed${NC}"
        return 1
    fi
    
    echo -e "\n${YELLOW}Step 2: Starting service...${NC}"
    sudo systemctl enable --now tailscaled
    echo -e "${GREEN}✓ Service started${NC}"
    
    echo -e "\n${YELLOW}Step 3: Connecting to network...${NC}"
    echo -e "${BLUE}Please authenticate in your browser when prompted${NC}"
    echo ""
    sudo tailscale up
    
    echo -e "\n${GREEN}${BOLD}════════════════════════════════════════════${NC}"
    echo -e "${GREEN}${BOLD}✅ Done No Errors${NC}"
    echo -e "${GREEN}${BOLD}════════════════════════════════════════════${NC}"
}

# Function to uninstall Tailscale
uninstall_tailscale() {
    echo -e "\n${RED}${BOLD}╔══════════════════════════════════════════╗${NC}"
    echo -e "${RED}${BOLD}║         Uninstalling wait a sec            ║${NC}"
    echo -e "${RED}${BOLD}╚══════════════════════════════════════════╝${NC}"
    
    echo -e "\n${RED}⚠ WARNING: This will completely remove Tailscale${NC}"
    echo -e "${RED}   and all its configuration data.${NC}"
    echo ""
    
    read -p "Are you sure? (yes/no): " confirm
    if [[ ! $confirm =~ ^[Yy][Ee]?[Ss]?$ ]]; then
        echo -e "\n${GREEN}Cancelled. Tailscale was NOT removed.${NC}"
        return
    fi
    
    echo -e "\n${YELLOW}Step 1: Stopping service...${NC}"
    sudo systemctl stop tailscaled
    sudo systemctl disable tailscaled
    echo -e "${GREEN}✓ Service stopped${NC}"
    
    echo -e "\n${YELLOW}Step 2: Removing package...${NC}"
    sudo apt purge tailscale -y
    echo -e "${GREEN}✓ Package removed${NC}"
    
    echo -e "\n${YELLOW}Step 3: Cleaning up files...${NC}"
    sudo rm -rf /var/lib/tailscale /etc/tailscale /var/cache/tailscale
    echo -e "${GREEN}✓ Files cleaned${NC}"
    
    echo -e "\n${YELLOW}Step 4: Removing dependencies...${NC}"
    sudo apt autoremove -y
    echo -e "${GREEN}✓ Dependencies removed${NC}"
    
    echo -e "\n${RED}${BOLD}════════════════════════════════════════════${NC}"
    echo -e "${RED}${BOLD}🗑️  TAILSCALE COMPLETELY REMOVED!${NC}"
    echo -e "${RED}${BOLD}════════════════════════════════════════════${NC}"
}

# Main menu
while true; do
    display_header
    check_status
    echo ""
    echo -e "${BOLD}══════════════════════════════════════════${NC}"
    echo -e "  ${GREEN}[1]${NC} ${BOLD}📥 Install Tailscale${NC}"
    echo -e "  ${RED}[2]${NC} ${BOLD}🗑️  Uninstall Tailscale${NC}"
    echo -e "  ${YELLOW}[3]${NC} ${BOLD}🚪 Exit${NC}"
    echo -e "${BOLD}══════════════════════════════════════════${NC}"
    echo ""
    
    read -p "Select option [1-3]: " option
    
    case $option in
        1)
            install_tailscale
            ;;
        2)
            uninstall_tailscale
            ;;
        3)
            echo -e "\n${CYAN}Goodbye!${NC}\n"
            exit 0
            ;;
        *)
            echo -e "\n${RED}Invalid option! Choose 1, 2, or 3${NC}"
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
done

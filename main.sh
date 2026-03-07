#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then 
  echo -e "\033[0;31m❌ Please run this script with sudo or as root.\033[0m"
  exit 1
fi

# Colors for output - RED THEME
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Function to print section headers
print_header_rule() {
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Big ASCII headers
big_header() {
    local title="$1"
    echo -e "${RED}"
    case "$title" in
        "MAIN MENU")
cat <<'EOF'
  ██████  ██░ ██  ▒█████   ▄████▄   ██ ▄█▀
▒██    ▒ ▓██░ ██▒▒██▒  ██▒▒██▀ ▀█   ██▄█▒ 
░ ▓██▄   ▒██▀▀██░▒██░  ██▒▒▓█    ▄ ▓███▄░ 
  ▒   ██▒░▓█ ░██ ▒██   ██░▒▓▓▄ ▄██▒▓██ █▄ 
▒██████▒▒░▓█▒░██▓░ ████▓▒░▒ ▓███▀ ░▒██▒ █▄
▒ ▒▓▒ ▒ ░ ▒ ░░▒░▒░ ▒░▒░▒░ ░ ░▒ ▒  ░▒ ▒▒ ▓▒
░ ░▒  ░ ░ ▒ ░▒░ ░  ░ ▒ ▒░   ░  ▒   ░ ░▒ ▒░
░  ░  ░   ░  ░░ ░░ ░ ░ ▒  ░        ░ ░░ ░ 
      ░   ░  ░  ░    ░ ░  ░ ░      ░  ░   
                          ░               
EOF
            ;;
        "SYSTEM INFORMATION")
cat <<'EOF'
▓█████▄ ▓█████  ███▄    █  ██▓▒███████▒
▒██▀ ██▌▓█   ▀  ██ ▀█   █ ▓██▒▒ ▒ ▒ ▄▀░
░██   █▌▒███   ▓██  ▀█ ██▒▒██▒░ ▒ ▄▀▒░ 
░▓█▄   ▌▒▓█  ▄ ▓██▒  ▐▌██▒░██░  ▄▀▒   ░
░▒████▓ ░▒████▒▒██░   ▓██░░██░▒███████▒
 ▒▒▓  ▒ ░░ ▒░ ░░ ▒░   ▒ ▒ ░▓  ░▒▒ ▓░▒░▒
 ░ ▒  ▒  ░ ░  ░░ ░░   ░ ▒░ ▒ ░░░▒ ▒ ░ ▒
 ░ ░  ░    ░      ░   ░ ░  ▒ ░░ ░ ░ ░ ░
   ░       ░  ░         ░  ░    ░ ░    
 ░                            ░        
EOF
            ;;
        "DATABASE SETUP")
cat <<'EOF'
▓█████▄  ▄▄▄     ▄▄▄█████▓ ▄▄▄           ██████  ██░ ██  ▒█████   ▄████▄   ██ ▄█▀
▒██▀ ██▌▒████▄   ▓  ██▒ ▓▒▒████▄       ▒██    ▒ ▓██░ ██▒▒██▒  ██▒▒██▀ ▀█   ██▄█▒ 
░██   █▌▒██  ▀█▄ ▒ ▓██░ ▒░▒██  ▀█▄     ░ ▓██▄   ▒██▀▀██░▒██░  ██▒▒▓█    ▄ ▓███▄░ 
░▓█▄   ▌░██▄▄▄▄██░ ▓██▓ ░ ░██▄▄▄▄██      ▒   ██▒░▓█ ░██ ▒██   ██░▒▓▓▄ ▄██▒▓██ █▄ 
░▒████▓  ▓█   ▓██▒ ▒██▒ ░  ▓█   ▓██▒   ▒██████▒▒░▓█▒░██▓░ ████▓▒░▒ ▓███▀ ░▒██▒ █▄
 ▒▒▓  ▒  ▒▒   ▓▒█░ ▒ ░░    ▒▒   ▓▒█░   ▒ ▒▓▒ ▒ ░ ▒ ░░▒░▒░ ▒░▒░▒░ ░ ░▒ ▒  ░▒ ▒▒ ▓▒
 ░ ▒  ▒   ▒   ▒▒ ░   ░      ▒   ▒▒ ░   ░ ░▒  ░ ░ ▒ ░▒░ ░  ░ ▒ ▒░   ░  ▒   ░ ░▒ ▒░
 ░ ░  ░   ░   ▒    ░        ░   ▒      ░  ░  ░   ░  ░░ ░░ ░ ░ ▒  ░        ░ ░░ ░ 
   ░          ░  ░              ░  ░         ░   ░  ░  ░    ░ ░  ░ ░      ░  ░   
 ░                                                               ░               
EOF
            ;;
        *)
            echo -e "${BOLD}${title}${NC}"
            ;;
    esac
    echo -e "${NC}"
}

# Status helpers
print_status() { echo -e "${YELLOW}⏳ $1...${NC}"; }
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_warning() { echo -e "${MAGENTA}⚠️  $1${NC}"; }

# Dependency check
check_curl() {
    if ! command -v curl &>/dev/null; then
        print_status "Installing curl"
        apt-get update -y && apt-get install -y curl
    fi
}

# Main script runner
run_remote_script() {
    local url=$1
    local script_name
    script_name=$(basename "$url" .sh | sed 's/.*/\u&/')

    clear
    print_header_rule
    big_header "MAIN MENU"
    print_header_rule
    echo -e "${RED}Running: ${BOLD}${script_name}${NC}"
    print_header_rule

    check_curl
    local temp_script
    temp_script=$(mktemp)

    if curl -fsSL "$url" -o "$temp_script"; then
        chmod +x "$temp_script"
        bash "$temp_script"
        local exit_code=$?
        rm -f "$temp_script"
        [ $exit_code -eq 0 ] && print_success "Done!" || print_error "Failed (Code $exit_code)"
    else
        rm -f "$temp_script"
        print_error "Download failed. Check URL: $url"
    fi

    echo -e ""
    read -p "$(echo -e "${YELLOW}Press Enter to return...${NC}")" -n 1
}

blueprint_theme_menu() {
    while true; do
        clear
        print_header_rule
        big_header "MAIN MENU"
        echo -e "${RED}           🔧 BLUEPRINT + THEME + EXTENSIONS            ${NC}"
        print_header_rule

        echo -e "${WHITE}${BOLD}  1)${NC} ${RED}Blueprint Setup${NC}"
        echo -e "${WHITE}${BOLD}  2)${NC} ${RED}Themes + Extensions${NC}"
        echo -e "${WHITE}${BOLD}  0)${NC} ${RED}Back to Main Menu${NC}"

        print_header_rule
        read -p "Select option: " subchoice

        case $subchoice in
            1) run_remote_script "https://raw.githubusercontent.com/shockbtylelite/scripts/refs/heads/main/print2.sh" ;;
            2) run_remote_script "https://raw.githubusercontent.com/shockbtylelite/scripts/refs/heads/main/addon.sh" ;;
            0) return ;;
            *) print_error "Invalid choice"; sleep 1 ;;
        esac
    done
}

system_info() {
    clear
    print_header_rule
    big_header "SYSTEM INFORMATION"
    print_header_rule
    echo -e "${WHITE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${WHITE}║   ${RED}•${NC} ${GREEN}Hostname:${NC} $(hostname)${NC}"
    echo -e "${WHITE}║   ${RED}•${NC} ${GREEN}System:${NC} $(uname -srm)${NC}"
    echo -e "${WHITE}║   ${RED}•${NC} ${GREEN}Uptime:${NC} $(uptime -p | sed 's/up //')${NC}"
    echo -e "${WHITE}║   ${RED}•${NC} ${GREEN}Memory:${NC} $(free -h | awk '/Mem:/ {print $3"/"$2}')${NC}"
    echo -e "${WHITE}╚═══════════════════════════════════════════════╝${NC}"
    echo ""
    read -p "Press Enter to return..." -n 1
}

show_menu() {
    clear
    print_header_rule
    echo -e "${RED}           🚀 Shock Manager Rework 🚀           ${NC}"
    print_header_rule
    big_header "MAIN MENU"
    print_header_rule
    echo -e "  ${WHITE}1)${NC} ${RED}Pterodactyl Panel${NC}   ${WHITE}5)${NC} ${RED}Cloudflared${NC}"
    echo -e "  ${WHITE}2)${NC} ${RED}Wings Manager${NC}       ${WHITE}6)${NC} ${RED}System Fetch${NC}"
    echo -e "  ${WHITE}3)${NC} ${RED}Uninstaller${NC}         ${WHITE}7)${NC} ${RED}TailScale${NC}"
    echo -e "  ${WHITE}4)${NC} ${RED}Blueprint/Themes${NC}    ${WHITE}8)${NC} ${RED}Database Manager${NC}"
    echo -e "  ${WHITE}0)${NC} ${RED}Exit${NC}"
    print_header_rule
    echo -ne "${YELLOW}📝 Choice [0-8]: ${NC}"
}

# --- START ---
clear
print_header_rule
big_header "MAIN MENU"
echo -e "${RED}          Starting Shock Hosting Manager...${NC}"
print_header_rule
sleep 1

while true; do
    show_menu
    read -r choice

    case $choice in
        1) run_remote_script "https://raw.githubusercontent.com/shockbtylelite/scripts/refs/heads/main/panel.sh" ;;
        2) run_remote_script "https://raw.githubusercontent.com/shockbtylelite/scripts/refs/heads/main/wings2.sh" ;;
        3) run_remote_script "https://raw.githubusercontent.com/shockbtylelite/scripts/refs/heads/main/remove2.sh" ;;
        4) blueprint_theme_menu ;;
        5) run_remote_script "https://raw.githubusercontent.com/shockbtylelite/scripts/refs/heads/main/flare2.sh" ;;
        6) system_info ;;
        7) run_remote_script "https://raw.githubusercontent.com/shockbtylelite/scripts/refs/heads/main/tail2.sh" ;;
        8)
            clear
            big_header "DATABASE SETUP"
            read -p "Database User: " DB_USER
            read -sp "Password: " DB_PASS
            echo -e "\n${YELLOW}Configuring...${NC}"
            
            # Using --force to bypass prompts if possible
            mysql -u root <<MYSQL_SCRIPT
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
MYSQL_SCRIPT

            CONF_FILE="/etc/mysql/mariadb.conf.d/50-server.cnf"
            if [ -f "$CONF_FILE" ]; then
                sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' "$CONF_FILE"
                systemctl restart mysql mariadb 2>/dev/null
                ufw allow 3306/tcp 2>/dev/null
                print_success "User '$DB_USER' created and remote access enabled."
            else
                print_warning "Config not found at $CONF_FILE. Check manual setup."
            fi
            read -p "Press Enter..." -n 1
            ;;
        0) exit 0 ;;
        *) print_error "Invalid option"; sleep 1 ;;
    esac
done

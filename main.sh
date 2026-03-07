#!/bin/bash

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

# Function to print section headers (RED theme)
print_header_rule() {
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Big ASCII header using heredoc (RED theme)
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
        "WELCOME")
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
        "BLUEPRINT+THEME+EXTENSIONS")
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
        *)
            echo -e "${BOLD}${title}${NC}"
            ;;
    esac
    echo -e "${NC}"
}

# Function to print status messages
print_status() { echo -e "${YELLOW}⏳ $1...${NC}"; }
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_warning() { echo -e "${MAGENTA}⚠️  $1${NC}"; }

# Check if curl is installed
check_curl() {
    if ! command -v curl &>/dev/null; then
        print_error "curl is not installed"
        print_status "Installing curl..."
        if command -v apt-get &>/dev/null; then
            sudo apt-get update && sudo apt-get install -y curl
        elif command -v yum &>/dev/null; then
            sudo yum install -y curl
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y curl
        else
            print_error "Could not install curl automatically. Please install it manually"
            exit 1
        fi
        print_success "curl installed successfully"
    fi
}

# Function to run remote scripts
run_remote_script() {
    local url=$1
    local script_name
    script_name=$(basename "$url" .sh)
    script_name=$(echo "$script_name" | sed 's/.*/\u&/')

    print_header_rule
    big_header "WELCOME"
    print_header_rule
    echo -e "${RED}Running: ${BOLD}${script_name}${NC}"
    print_header_rule

    check_curl
    local temp_script
    temp_script=$(mktemp)
    print_status "Downloading script"

    if curl -fsSL "$url" -o "$temp_script"; then
        print_success "Download successful"
        chmod +x "$temp_script"
        bash "$temp_script"
        local exit_code=$?
        rm -f "$temp_script"
        if [ $exit_code -eq 0 ]; then
            print_success "Script executed successfully"
        else
            print_error "Script execution failed with exit code: $exit_code"
        fi
    else
        print_error "Failed to download script"
    fi

    echo -e ""
    read -p "$(echo -e "${YELLOW}Press Enter to continue...${NC}")" -n 1
}

# Function for combined Blueprint+Theme+Extensions menu
blueprint_theme_menu() {
    while true; do
        clear
        print_header_rule
        echo -e "${RED}           🔧 BLUEPRINT + THEME + EXTENSIONS            ${NC}"
        print_header_rule
        big_header "BLUEPRINT+THEME+EXTENSIONS"
        print_header_rule

        echo -e "${WHITE}${BOLD}  1)${NC} ${RED}${BOLD}Blueprint Setup${NC}"
        echo -e "${WHITE}${BOLD}  2)${NC} ${RED}${BOLD}Themes + Extensions${NC}"
        echo -e "${WHITE}${BOLD}  0)${NC} ${RED}${BOLD}Back to Main Menu${NC}"

        print_header_rule
        echo -e "${YELLOW}${BOLD}📝 Select an option [0-2]: ${NC}"
        read -r subchoice

        case $subchoice in
            1)
                run_remote_script "https://raw.githubusercontent.com/shockbtylelite/scripts/refs/heads/main/print2.sh"
                ;;
            2)
                print_header_rule
                big_header "WELCOME"
                print_header_rule
                echo -e "${RED}Running: ${BOLD}BluePrint Manager${NC}"
                print_header_rule
                print_status "Opening BluePrint Manager"
                bash <(curl -s https://raw.githubusercontent.com/shockbtylelite/scripts/refs/heads/main/addon.sh)
                print_success "success"
                echo -e ""
                read -p "$(echo -e "${YELLOW}Go Home${NC}")" -n 1
                ;;
            0)
                return 0
                ;;
            *)
                print_error "Invalid option! Please choose between 0-2"
                sleep 1.2
                ;;
        esac
    done
}

# Function to show system info
system_info() {
    print_header_rule
    big_header "SYSTEM INFORMATION"
    print_header_rule

    echo -e "${WHITE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${WHITE}║               📊 SYSTEM FETCH            ║${NC}"
    echo -e "${WHITE}╠═══════════════════════════════════════════════╣${NC}"
    echo -e "${WHITE}║   ${RED}•${NC} ${GREEN}Hostname:${NC} ${WHITE}$(hostname)${NC}                  ${WHITE}║${NC}"
    echo -e "${WHITE}║   ${RED}•${NC} ${GREEN}User:${NC} ${WHITE}$(whoami)${NC}                          ${WHITE}║${NC}"
    echo -e "${WHITE}║   ${RED}•${NC} ${GREEN}Directory:${NC} ${WHITE}$(pwd)${NC}           ${WHITE}║${NC}"
    echo -e "${WHITE}║   ${RED}•${NC} ${GREEN}System:${NC} ${WHITE}$(uname -srm)${NC}              ${WHITE}║${NC}"
    echo -e "${WHITE}║   ${RED}•${NC} ${GREEN}Uptime:${NC} ${WHITE}$(uptime -p | sed 's/up //')${NC}               ${WHITE}║${NC}"
    echo -e "${WHITE}║   ${RED}•${NC} ${GREEN}Memory:${NC} ${WHITE}$(free -h | awk '/Mem:/ {print $3"/"$2}')${NC}               ${WHITE}║${NC}"
    echo -e "${WHITE}║   ${RED}•${NC} ${GREEN}Disk:${NC} ${WHITE}$(df -h / | awk 'NR==2 {print $3"/"$2 " ("$5")"}')${NC}        ${WHITE}║${NC}"
    echo -e "${WHITE}╚═══════════════════════════════════════════════╝${NC}"

    echo -e ""
    read -p "$(echo -e "${YELLOW}Press Enter to continue...${NC}")" -n 1
}

# Function to display the main menu (REDUCED - REMOVED 3,5,7,11)
show_menu() {
    clear
    print_header_rule
    echo -e "${RED}           🚀 Shock Managers 🚀           ${NC}"
    echo -e "${RED}         Copyed Jishu And Made A Rework 📜${NC}"
    print_header_rule

    big_header "MAIN MENU"
    print_header_rule

    echo -e "${WHITE}${BOLD}  1)${NC} ${RED}${BOLD}Pterodactyl Panel Manager${NC}"
    echo -e "${WHITE}${BOLD}  2)${NC} ${RED}${BOLD}Wings Manager${NC}"
    echo -e "${WHITE}${BOLD}  3)${NC} ${RED}${BOLD}Uninstaller Manager${NC}"
    echo -e "${WHITE}${BOLD}  4)${NC} ${RED}${BOLD}BluePrint Manager${NC}"
    echo -e "${WHITE}${BOLD}  5)${NC} ${RED}${BOLD}Cloudflared Manager${NC}"
    echo -e "${WHITE}${BOLD}  6)${NC} ${RED}${BOLD}System Fetch${NC}"
    echo -e "${WHITE}${BOLD}  7)${NC} ${RED}${BOLD}TailScale Manager${NC}"
    echo -e "${WHITE}${BOLD}  8)${NC} ${RED}${BOLD}Database Manager${NC}"
    echo -e "${WHITE}${BOLD}  0)${NC} ${RED}${BOLD}Exit${NC}"

    print_header_rule
    echo -e "${YELLOW}${BOLD}📝 Select an option [0-8]: ${NC}"
}

# Welcome animation (RED theme)
welcome_animation() {
    clear
    print_header_rule
    echo -e "${RED}"
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
    echo -e "${NC}"
    echo -e "${RED}                  Shock Hosting manager${NC}"
    print_header_rule
    sleep 1.2
}

# Main loop
welcome_animation

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
            print_header_rule
            big_header "DATABASE SETUP"
            print_header_rule
            echo -e "${RED}Running: ${BOLD}MySQL / MariaDB Database Setup${NC}"
            print_header_rule

            read -p "Enter new database username: " DB_USER
            read -sp "Enter password for $DB_USER: " DB_PASS
            echo ""
            echo -e "${YELLOW}Creating database user '$DB_USER'...${NC}"

            mysql -u root -p <<MYSQL_SCRIPT
CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
MYSQL_SCRIPT

            CONF_FILE="/etc/mysql/mariadb.conf.d/50-server.cnf"
            if [ -f "$CONF_FILE" ]; then
                echo -e "${YELLOW}Updating bind-address in $CONF_FILE...${NC}"
                sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' "$CONF_FILE"
            else
                echo -e "${MAGENTA}⚠️  Config file not found: $CONF_FILE${NC}"
            fi

            echo -e "${YELLOW}Restarting MySQL and MariaDB services...${NC}"
            systemctl restart mysql 2>/dev/null
            systemctl restart mariadb 2>/dev/null

            if command -v ufw &>/dev/null; then
                ufw allow 3306/tcp >/dev/null 2>&1 && echo -e "${GREEN}Opened port 3306 for remote connections${NC}"
            fi

            echo -e "${GREEN}✅ Database user '$DB_USER' created and remote access enabled!${NC}"

            echo -e ""
            read -p "$(echo -e "${YELLOW}Press Enter to continue...${NC}")" -n 1
            ;;
        0)
            echo -e "${GREEN}Exiting Jishnu Hosting Manager...${NC}"
            print_header_rule
            echo -e "${RED}           Thank you for using Shock Manager 🚀       ${NC}"
            print_header_rule
            sleep 1
            exit 0
            ;;
        *)
            print_error "Invalid option! Please choose between 0-8"
            sleep 1.2
            ;;
    esac
done


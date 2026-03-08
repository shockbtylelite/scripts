#!/bin/bash
set -euo pipefail

# =============================
# Pure QEMU VM Manager (No KVM, No SSH, No Graphics)
# =============================

# Function to display header
display_header() {
    clear 2>/dev/null || true
    cat << "EOF"
========================================================================
 Pure QEMU VM Manager - No KVM / No SSH / Terminal Only
========================================================================
EOF
    echo
}

# Function to display colored output
print_status() {
    local type=$1
    local message=$2

    case $type in
        "INFO") echo -e "\033[1;34m[INFO]\033[0m $message" ;;
        "WARN") echo -e "\033[1;33m[WARN]\033[0m $message" ;;
        "ERROR") echo -e "\033[1;31m[ERROR]\033[0m $message" ;;
        "SUCCESS") echo -e "\033[1;32m[SUCCESS]\033[0m $message" ;;
        "INPUT") echo -e "\033[1;36m[INPUT]\033[0m $message" ;;
        *) echo "[$type] $message" ;;
    esac
}

# Function to validate input
validate_input() {
    local type=$1
    local value=$2

    case $type in
        "number")
            if ! [[ "$value" =~ ^[0-9]+$ ]]; then
                print_status "ERROR" "Must be a number"
                return 1
            fi
            ;;
        "size")
            if ! [[ "$value" =~ ^[0-9]+[GgMm]$ ]]; then
                print_status "ERROR" "Must be a size with unit (e.g., 100G, 512M)"
                return 1
            fi
            ;;
        "name")
            if ! [[ "$value" =~ ^[a-zA-Z0-9_-]+$ ]]; then
                print_status "ERROR" "VM name can only contain letters, numbers, hyphens, and underscores"
                return 1
            fi
            ;;
        "username")
            if ! [[ "$value" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
                print_status "ERROR" "Username must start with a letter or underscore, and contain only letters, numbers, hyphens, and underscores"
                return 1
            fi
            ;;
    esac
    return 0
}

# Function to check dependencies
check_dependencies() {
    local deps=("qemu-system-x86_64" "wget" "qemu-img")
    local missing_deps=()

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done

    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_status "ERROR" "Missing dependencies: ${missing_deps[*]}"
        print_status "INFO" "On Ubuntu/Debian, try: sudo apt install qemu-system-x86 wget"
        print_status "INFO" "On Fedora/RHEL, try: sudo dnf install qemu-system-x86 wget"
        exit 1
    fi
}

# Function to cleanup temporary files
cleanup() {
    if [ -f "user-data" ]; then rm -f "user-data"; fi
    if [ -f "meta-data" ]; then rm -f "meta-data"; fi
    if [ -f "network-config" ]; then rm -f "network-config"; fi
}

# Function to get all VM configurations
get_vm_list() {
    find "$VM_DIR" -name "*.conf" -exec basename {} .conf \; 2>/dev/null | sort
}

# Function to load VM configuration
load_vm_config() {
    local vm_name=$1
    local config_file="$VM_DIR/$vm_name.conf"

    if [[ -f "$config_file" ]]; then
        unset VM_NAME OS_TYPE CODENAME IMG_URL HOSTNAME USERNAME PASSWORD
        unset DISK_SIZE MEMORY CPUS PORT_FORWARDS IMG_FILE SEED_FILE CREATED
        
        source "$config_file"
        return 0
    else
        print_status "ERROR" "Configuration for VM '$vm_name' not found"
        return 1
    fi
}

# Function to save VM configuration
save_vm_config() {
    local config_file="$VM_DIR/$VM_NAME.conf"

    cat > "$config_file" << EOF
VM_NAME="$VM_NAME"
OS_TYPE="$OS_TYPE"
CODENAME="$CODENAME"
IMG_URL="$IMG_URL"
HOSTNAME="$HOSTNAME"
USERNAME="$USERNAME"
PASSWORD="$PASSWORD"
DISK_SIZE="$DISK_SIZE"
MEMORY="$MEMORY"
CPUS="$CPUS"
PORT_FORWARDS="$PORT_FORWARDS"
IMG_FILE="$IMG_FILE"
SEED_FILE="$SEED_FILE"
CREATED="$CREATED"
EOF
}

# Function to create cloud-init ISO without cloud-localds
create_seed_iso() {
    local seed_file=$1
    local user_data_file=$2
    local meta_data_file=$3
    
    local temp_dir=$(mktemp -d)
    
    cp "$user_data_file" "$temp_dir/user-data"
    cp "$meta_data_file" "$temp_dir/meta-data"
    
    if command -v mkisofs &> /dev/null; then
        mkisofs -output "$seed_file" -volid cidata -joliet -rock "$temp_dir/user-data" "$temp_dir/meta-data" 2>/dev/null
    elif command -v genisoimage &> /dev/null; then
        genisoimage -output "$seed_file" -volid cidata -joliet -rock "$temp_dir/user-data" "$temp_dir/meta-data" 2>/dev/null
    elif command -v xorrisofs &> /dev/null; then
        xorrisofs -output "$seed_file" -volid cidata -joliet -rock "$temp_dir/user-data" "$temp_dir/meta-data" 2>/dev/null
    else
        print_status "WARN" "No ISO creation tools found."
        print_status "INFO" "Please install genisoimage: sudo apt install genisoimage (or xorriso)"
        rm -rf "$temp_dir"
        return 1
    fi
    
    rm -rf "$temp_dir"
    return 0
}

# Function to create a new VM
create_new_vm() {
    print_status "INFO" "Creating a new VM..."
    
    while true; do
        read -p "$(print_status "INPUT" "Enter VM name: ")" VM_NAME
        if validate_input "name" "$VM_NAME"; then
            if [[ -f "$VM_DIR/$VM_NAME.conf" ]]; then
                print_status "ERROR" "VM with name '$VM_NAME' already exists"
            else
                break
            fi
        fi
    done

    echo "Select OS:"
    local i=1
    local os_keys=()
    for os_name in "${!OS_OPTIONS[@]}"; do
        os_keys+=("$os_name")
        echo "  $i) $os_name"
        ((i++))
    done
    
    while true; do
        read -p "$(print_status "INPUT" "Enter OS number: ")" os_choice
        if [[ "$os_choice" =~ ^[0-9]+$ ]] && [ "$os_choice" -ge 1 ] && [ "$os_choice" -le ${#os_keys[@]} ]; then
            local selected_os="${os_keys[$((os_choice-1))]}"
            local os_info="${OS_OPTIONS[$selected_os]}"
            IFS='|' read -r OS_TYPE CODENAME IMG_URL HOSTNAME USERNAME PASSWORD <<< "$os_info"
            break
        else
            print_status "ERROR" "Invalid selection"
        fi
    done

    while true; do
        read -p "$(print_status "INPUT" "Enter hostname (default: $HOSTNAME): ")" input_hostname
        HOSTNAME="${input_hostname:-$HOSTNAME}"
        if validate_input "name" "$HOSTNAME"; then
            break
        fi
    done

    while true; do
        read -p "$(print_status "INPUT" "Enter username (default: $USERNAME): ")" input_username
        USERNAME="${input_username:-$USERNAME}"
        if validate_input "username" "$USERNAME"; then
            break
        fi
    done

    while true; do
        read -s -p "$(print_status "INPUT" "Enter password (default: $PASSWORD): ")" input_password
        echo
        PASSWORD="${input_password:-$PASSWORD}"
        if [ -n "$PASSWORD" ]; then
            break
        else
            print_status "ERROR" "Password cannot be empty"
        fi
    done

    while true; do
        read -p "$(print_status "INPUT" "Enter disk size (e.g., 20G, default: 20G): ")" DISK_SIZE
        DISK_SIZE="${DISK_SIZE:-20G}"
        if validate_input "size" "$DISK_SIZE"; then
            break
        fi
    done

    while true; do
        read -p "$(print_status "INPUT" "Enter memory in MB (default: 2048): ")" MEMORY
        MEMORY="${MEMORY:-2048}"
        if validate_input "number" "$MEMORY"; then
            break
        fi
    done

    while true; do
        read -p "$(print_status "INPUT" "Enter number of CPUs (default: 2): ")" CPUS
        CPUS="${CPUS:-2}"
        if validate_input "number" "$CPUS"; then
            break
        fi
    done

    read -p "$(print_status "INPUT" "Additional port forwards (e.g., 8080:80, press Enter for none): ")" PORT_FORWARDS

    IMG_FILE="$VM_DIR/$VM_NAME.img"
    SEED_FILE="$VM_DIR/$VM_NAME-seed.iso"
    CREATED="$(date)"

    setup_vm_image
    save_vm_config
}

# Function to setup VM image
setup_vm_image() {
    print_status "INFO" "Downloading and preparing image..."

    mkdir -p "$VM_DIR"

    if [[ -f "$IMG_FILE" ]]; then
        print_status "INFO" "Image file already exists. Skipping download."
    else
        print_status "INFO" "Downloading image from $IMG_URL..."
        if ! wget --progress=bar:force "$IMG_URL" -O "$IMG_FILE.tmp"; then
            print_status "ERROR" "Failed to download image from $IMG_URL"
            exit 1
        fi
        mv "$IMG_FILE.tmp" "$IMG_FILE"
    fi

    if ! qemu-img resize "$IMG_FILE" "$DISK_SIZE" 2>/dev/null; then
        print_status "WARN" "Failed to resize disk image. Creating new image with specified size..."
        rm -f "$IMG_FILE"
        qemu-img create -f qcow2 "$IMG_FILE" "$DISK_SIZE"
    fi

    cat > user-data << EOF
#cloud-config
hostname: $HOSTNAME
manage_etc_hosts: true
users:
  - name: $USERNAME
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, admin
    home: /home/$USERNAME
    shell: /bin/bash
    lock_passwd: false
    plain_text_passwd: $PASSWORD
ssh_pwauth: true
chpasswd:
  expire: false
package_update: true
package_upgrade: false
packages:
  - qemu-guest-agent
  - curl
  - wget
  - nano
  - vim
  - htop
runcmd:
  - systemctl enable qemu-guest-agent
  - systemctl start qemu-guest-agent
EOF

    cat > meta-data << EOF
instance-id: $VM_NAME
local-hostname: $HOSTNAME
EOF

    print_status "INFO" "Creating cloud-init seed ISO..."
    if ! create_seed_iso "$SEED_FILE" "user-data" "meta-data"; then
        print_status "ERROR" "Failed to create seed ISO. Please install genisoimage or xorriso."
        exit 1
    fi
    
    print_status "SUCCESS" "VM image prepared successfully"
}

# Function to start a VM (NO GRAPHICS - direct terminal)
start_vm() {
    local vm_name=$1

    if load_vm_config "$vm_name"; then
        if is_vm_running "$vm_name"; then
            print_status "WARN" "VM '$vm_name' is already running"
            return 1
        fi

        print_status "INFO" "Starting VM: $vm_name"
        print_status "INFO" "Press Ctrl+A then X to exit the VM"

        # Build port forwards for user networking
        local netdev_args="user,id=net0"
        if [ -n "$PORT_FORWARDS" ]; then
            IFS=',' read -ra forwards <<< "$PORT_FORWARDS"
            for forward in "${forwards[@]}"; do
                netdev_args="$netdev_args,hostfwd=tcp::$forward"
            done
        fi

        # Start VM with NO GRAPHICS - nographic mode for full terminal access
        # This runs QEMU in the foreground with serial output to console
        qemu-system-x86_64 \
            -machine type=q35,accel=tcg \
            -cpu max \
            -smp "$CPUS" \
            -m "$MEMORY" \
            -drive file="$IMG_FILE",format=qcow2,if=virtio \
            -drive file="$SEED_FILE",format=raw,if=virtio,readonly=on \
            -netdev "$netdev_args" \
            -device virtio-net-pci,netdev=net0 \
            -nographic \
            -serial mon:stdio \
            -pidfile "$VM_DIR/$VM_NAME.pid"

        # When QEMU exits, clean up pid file
        rm -f "$VM_DIR/$VM_NAME.pid"
        
        print_status "INFO" "VM $vm_name stopped"
    fi
}

# Function to check if VM is running
is_vm_running() {
    local vm_name=$1
    local pid_file="$VM_DIR/$vm_name.pid"
    
    if [[ -f "$pid_file" ]]; then
        local pid=$(cat "$pid_file" 2>/dev/null)
        if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
            return 0
        fi
    fi
    return 1
}

# Function to show VM info
show_vm_info() {
    local vm_name=$1

    if load_vm_config "$vm_name"; then
        echo "=========================================="
        echo "VM Name: $VM_NAME"
        echo "OS Type: $OS_TYPE ($CODENAME)"
        echo "Hostname: $HOSTNAME"
        echo "Username: $USERNAME"
        echo "Disk Size: $DISK_SIZE"
        echo "Memory: ${MEMORY}MB"
        echo "CPUs: $CPUS"
        echo "Port Forwards: ${PORT_FORWARDS:-None}"
        echo "Created: $CREATED"
        echo "Status: $(is_vm_running "$vm_name" && echo "Running" || echo "Stopped")"
        echo "=========================================="
        
        read -p "$(print_status "INPUT" "Press Enter to continue...")"
    fi
}

# Function to delete a VM
delete_vm() {
    local vm_name=$1

    if load_vm_config "$vm_name"; then
        read -p "$(print_status "INPUT" "Are you sure you want to delete VM '$vm_name'? (yes/no): ")" confirm
        if [[ "$confirm" == "yes" ]]; then
            stop_vm "$vm_name" 2>/dev/null || true
            
            rm -f "$IMG_FILE" "$SEED_FILE" "$VM_DIR/$vm_name.conf" "$VM_DIR/$vm_name.pid"
            print_status "SUCCESS" "VM $vm_name deleted"
        else
            print_status "INFO" "Deletion cancelled"
        fi
    fi
}

# Function to stop a running VM
stop_vm() {
    local vm_name=$1

    if load_vm_config "$vm_name"; then
        if is_vm_running "$vm_name"; then
            print_status "INFO" "Stopping VM: $vm_name"
            local pid=$(cat "$VM_DIR/$vm_name.pid" 2>/dev/null)
            if [[ -n "$pid" ]]; then
                kill "$pid" 2>/dev/null || true
                sleep 2
                if is_vm_running "$vm_name"; then
                    print_status "WARN" "VM did not stop gracefully, forcing termination..."
                    kill -9 "$pid" 2>/dev/null || true
                fi
            fi
            rm -f "$VM_DIR/$vm_name.pid"
            print_status "SUCCESS" "VM $vm_name stopped"
        else
            print_status "INFO" "VM $vm_name is not running"
        fi
    fi
}

# Function to edit VM configuration
edit_vm_config() {
    local vm_name=$1

    if load_vm_config "$vm_name"; then
        print_status "INFO" "Editing VM: $vm_name"

        while true; do
            echo "What would you like to edit?"
            echo " 1) Hostname"
            echo " 2) Username"
            echo " 3) Password"
            echo " 4) Port Forwards"
            echo " 5) Memory (RAM)"
            echo " 6) CPU Count"
            echo " 7) Disk Size"
            echo " 0) Back to main menu"

            read -p "$(print_status "INPUT" "Enter your choice: ")" edit_choice

            case $edit_choice in
                1)
                    while true; do
                        read -p "$(print_status "INPUT" "Enter new hostname (current: $HOSTNAME): ")" new_hostname
                        new_hostname="${new_hostname:-$HOSTNAME}"
                        if validate_input "name" "$new_hostname"; then
                            HOSTNAME="$new_hostname"
                            break
                        fi
                    done
                    ;;
                2)
                    while true; do
                        read -p "$(print_status "INPUT" "Enter new username (current: $USERNAME): ")" new_username
                        new_username="${new_username:-$USERNAME}"
                        if validate_input "username" "$new_username"; then
                            USERNAME="$new_username"
                            break
                        fi
                    done
                    ;;
                3)
                    while true; do
                        read -s -p "$(print_status "INPUT" "Enter new password (current: ****): ")" new_password
                        echo
                        new_password="${new_password:-$PASSWORD}"
                        if [ -n "$new_password" ]; then
                            PASSWORD="$new_password"
                            break
                        else
                            print_status "ERROR" "Password cannot be empty"
                        fi
                    done
                    ;;
                4)
                    read -p "$(print_status "INPUT" "Additional port forwards (current: ${PORT_FORWARDS:-None}): ")" new_port_forwards
                    PORT_FORWARDS="${new_port_forwards:-$PORT_FORWARDS}"
                    ;;
                5)
                    while true; do
                        read -p "$(print_status "INPUT" "Enter new memory in MB (current: $MEMORY): ")" new_memory
                        new_memory="${new_memory:-$MEMORY}"
                        if validate_input "number" "$new_memory"; then
                            MEMORY="$new_memory"
                            break
                        fi
                    done
                    ;;
                6)
                    while true; do
                        read -p "$(print_status "INPUT" "Enter new CPU count (current: $CPUS): ")" new_cpus
                        new_cpus="${new_cpus:-$CPUS}"
                        if validate_input "number" "$new_cpus"; then
                            CPUS="$new_cpus"
                            break
                        fi
                    done
                    ;;
                7)
                    while true; do
                        read -p "$(print_status "INPUT" "Enter new disk size (current: $DISK_SIZE): ")" new_disk_size
                        new_disk_size="${new_disk_size:-$DISK_SIZE}"
                        if validate_input "size" "$new_disk_size"; then
                            if [[ "$new_disk_size" == "$DISK_SIZE" ]]; then
                                print_status "INFO" "New disk size is the same as current size. No changes made."
                                return 0
                            fi
                            
                            print_status "INFO" "Resizing disk to $new_disk_size..."
                            if qemu-img resize "$IMG_FILE" "$new_disk_size"; then
                                DISK_SIZE="$new_disk_size"
                                print_status "SUCCESS" "Disk resized successfully to $new_disk_size"
                            else
                                print_status "ERROR" "Failed to resize disk"
                                return 1
                            fi
                            break
                        fi
                    done
                    ;;
                0)
                    return 0
                    ;;
                *)
                    print_status "ERROR" "Invalid selection"
                    continue
                    ;;
            esac

            if [[ "$edit_choice" -eq 1 || "$edit_choice" -eq 2 || "$edit_choice" -eq 3 ]]; then
                print_status "INFO" "Updating cloud-init configuration..."
                setup_vm_image
            fi

            save_vm_config

            read -p "$(print_status "INPUT" "Continue editing? (y/N): ")" continue_editing
            if [[ ! "$continue_editing" =~ ^[Yy]$ ]]; then
                break
            fi
        done
    fi
}

# Main menu function
main_menu() {
    while true; do
        display_header

        local vms=($(get_vm_list))
        local vm_count=${#vms[@]}

        if [ $vm_count -gt 0 ]; then
            print_status "INFO" "Found $vm_count existing VM(s):"
            for i in "${!vms[@]}"; do
                local status="Stopped"
                if is_vm_running "${vms[$i]}"; then
                    status="Running"
                fi
                printf " %2d) %s (%s)\n" $((i+1)) "${vms[$i]}" "$status"
            done
            echo
        fi

        echo "Main Menu:"
        echo " 1) Create a new VM"
        if [ $vm_count -gt 0 ]; then
            echo " 2) Start a VM (Terminal mode - no graphics)"
            echo " 3) Stop a VM"
            echo " 4) Show VM info"
            echo " 5) Edit VM configuration"
            echo " 6) Delete a VM"
        fi
        echo " 0) Exit"
        echo

        read -p "$(print_status "INPUT" "Enter your choice: ")" choice

        case $choice in
            1)
                create_new_vm
                ;;
            2)
                if [ $vm_count -gt 0 ]; then
                    read -p "$(print_status "INPUT" "Enter VM number to start: ")" vm_num
                    if [[ "$vm_num" =~ ^[0-9]+$ ]] && [ "$vm_num" -ge 1 ] && [ "$vm_num" -le $vm_count ]; then
                        start_vm "${vms[$((vm_num-1))]}"
                    else
                        print_status "ERROR" "Invalid selection"
                    fi
                fi
                ;;
            3)
                if [ $vm_count -gt 0 ]; then
                    read -p "$(print_status "INPUT" "Enter VM number to stop: ")" vm_num
                    if [[ "$vm_num" =~ ^[0-9]+$ ]] && [ "$vm_num" -ge 1 ] && [ "$vm_num" -le $vm_count ]; then
                        stop_vm "${vms[$((vm_num-1))]}"
                    else
                        print_status "ERROR" "Invalid selection"
                    fi
                fi
                ;;
            4)
                if [ $vm_count -gt 0 ]; then
                    read -p "$(print_status "INPUT" "Enter VM number to show info: ")" vm_num
                    if [[ "$vm_num" =~ ^[0-9]+$ ]] && [ "$vm_num" -ge 1 ] && [ "$vm_num" -le $vm_count ]; then
                        show_vm_info "${vms[$((vm_num-1))]}"
                    else
                        print_status "ERROR" "Invalid selection"
                    fi
                fi
                ;;
            5)
                if [ $vm_count -gt 0 ]; then
                    read -p "$(print_status "INPUT" "Enter VM number to edit: ")" vm_num
                    if [[ "$vm_num" =~ ^[0-9]+$ ]] && [ "$vm_num" -ge 1 ] && [ "$vm_num" -le $vm_count ]; then
                        edit_vm_config "${vms[$((vm_num-1))]}"
                    else
                        print_status "ERROR" "Invalid selection"
                    fi
                fi
                ;;
            6)
                if [ $vm_count -gt 0 ]; then
                    read -p "$(print_status "INPUT" "Enter VM number to delete: ")" vm_num
                    if [[ "$vm_num" =~ ^[0-9]+$ ]] && [ "$vm_num" -ge 1 ] && [ "$vm_num" -le $vm_count ]; then
                        delete_vm "${vms[$((vm_num-1))]}"
                    else
                        print_status "ERROR" "Invalid selection"
                    fi
                fi
                ;;
            0)
                print_status "INFO" "Goodbye!"
                exit 0
                ;;
            *)
                print_status "ERROR" "Invalid option"
                ;;
        esac

        read -p "$(print_status "INPUT" "Press Enter to continue...")"
    done
}

# Set trap to cleanup on exit
trap cleanup EXIT

# Check dependencies
check_dependencies

# Initialize paths
VM_DIR="${VM_DIR:-$HOME/vms}"
mkdir -p "$VM_DIR"

# Supported OS list
declare -A OS_OPTIONS=(
    ["Ubuntu 22.04"]="ubuntu|jammy|https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img|ubuntu22|ubuntu|ubuntu"
    ["Ubuntu 24.04"]="ubuntu|noble|https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img|ubuntu24|ubuntu|ubuntu"
    ["Debian 11"]="debian|bullseye|https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-generic-amd64.qcow2|debian11|debian|debian"
    ["Debian 12"]="debian|bookworm|https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2|debian12|debian|debian"
    ["Fedora 40"]="fedora|40|https://download.fedoraproject.org/pub/fedora/linux/releases/40/Cloud/x86_64/images/Fedora-Cloud-Base-40-1.14.x86_64.qcow2|fedora40|fedora|fedora"
    ["CentOS Stream 9"]="centos|stream9|https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-latest.x86_64.qcow2|centos9|centos|centos"
    ["AlmaLinux 9"]="almalinux|9|https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2|almalinux9|alma|alma"
    ["Rocky Linux 9"]="rockylinux|9|https://download.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2|rocky9|rocky|rocky"
)

# Start the main menu
main_menu

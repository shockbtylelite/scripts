#!/bin/bash
# =====================================================
# Dirt VPS Bot by Deniz
# Modern VPS-in-VPS Manager
# Works in Docker, No KVM/Intel/AMD needed
# =====================================================

# -------- CONFIGURATION --------
VM_DIR="./vms"        # Directory to store VM disks
DEFAULT_MEM=1024      # Default VM memory in MB
DEFAULT_CPUS=1        # Default CPU cores
DEFAULT_SSH_PORT=2222 # SSH port for VM
USERNAME="vps"
PASSWORD="root"
GUI_MODE=false        # Set true to show VM GUI

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# -------- UTILITY FUNCTIONS --------
print_status() {
    local type=$1
    local msg=$2
    case $type in
        INFO) echo -e "${YELLOW}[INFO]${NC} $msg" ;;
        SUCCESS) echo -e "${GREEN}[SUCCESS]${NC} $msg" ;;
        ERROR) echo -e "${RED}[ERROR]${NC} $msg" ;;
    esac
}

ensure_dirs() {
    mkdir -p "$VM_DIR"
}

# -------- VM FUNCTIONS --------
list_vms() {
    echo "Existing VMs:"
    shopt -s nullglob
    local files=("$VM_DIR"/*.img)
    if [ ${#files[@]} -eq 0 ]; then
        echo " No VMs found."
    else
        local i=1
        for f in "${files[@]}"; do
            echo " $i) $(basename "$f" .img)"
            i=$((i+1))
        done
    fi
}

create_vm() {
    read -p "Enter VM name: " vm_name
    local vm_path="$VM_DIR/$vm_name.img"
    if [ -f "$vm_path" ]; then
        print_status ERROR "VM already exists!"
        return
    fi
    print_status INFO "Creating $vm_name with $DEFAULT_MEM MB RAM and $DEFAULT_CPUS CPU(s)..."
    qemu-img create -f qcow2 "$vm_path" 10G
    print_status SUCCESS "VM $vm_name created at $vm_path"
}

start_vm() {
    read -p "Enter VM name to start: " vm_name
    local vm_path="$VM_DIR/$vm_name.img"
    if [ ! -f "$vm_path" ]; then
        print_status ERROR "VM disk not found!"
        return
    fi
    print_status INFO "Starting VM: $vm_name"

    QEMU_CMD="qemu-system-x86_64 \
        -hda $vm_path \
        -m $DEFAULT_MEM \
        -smp $DEFAULT_CPUS \
        -net nic -net user,hostfwd=tcp::$DEFAULT_SSH_PORT-:22"

    if [ "$GUI_MODE" = true ]; then
        QEMU_CMD="$QEMU_CMD -vga std"
    else
        QEMU_CMD="$QEMU_CMD -nographic"
    fi

    print_status INFO "SSH: ssh -p $DEFAULT_SSH_PORT $USERNAME@localhost"
    print_status INFO "Password: $PASSWORD"
    eval "$QEMU_CMD &"
    sleep 2
    print_status SUCCESS "VM $vm_name started"
}

stop_vm() {
    read -p "Enter VM name to stop: " vm_name
    pkill -f "$VM_DIR/$vm_name.img" && print_status SUCCESS "VM $vm_name stopped" || print_status ERROR "VM not running"
}

delete_vm() {
    read -p "Enter VM name to delete: " vm_name
    local vm_path="$VM_DIR/$vm_name.img"
    if [ -f "$vm_path" ]; then
        rm -f "$vm_path"
        print_status SUCCESS "VM $vm_name deleted"
    else
        print_status ERROR "VM not found"
    fi
}

# -------- MAIN MENU --------
main_menu() {
    ensure_dirs
    while true; do
        echo "======================================================"
        echo " Dirt VPS Bot by Deniz (Docker/Nested VPS friendly)"
        echo "======================================================"
        list_vms
        echo "------------------------------------------------------"
        echo " 1) Create VM"
        echo " 2) Start VM"
        echo " 3) Stop VM"
        echo " 4) Delete VM"
        echo " 0) Exit"
        read -p "[INPUT] Enter choice: " choice
        case $choice in
            1) create_vm ;;
            2) start_vm ;;
            3) stop_vm ;;
            4) delete_vm ;;
            0) exit 0 ;;
            *) print_status ERROR "Invalid choice" ;;
        esac
    done
}

# -------- RUN SCRIPT --------
main_menu

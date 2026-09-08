#!/bin/bash

# ==========================================
# Linux Server Health Check Tool
# Author: Sri Soundarraj
# Description: A Bash-based Linux system
# health monitoring and administration tool.
# ==========================================

DATE=$(date '+%Y-%m-%d %H:%M:%S')

check_hostname() {
    echo ""
    echo "Hostname:"
    hostname
}

check_ip() {
    echo ""
    echo "IP Address:"
    hostname -I
}

check_os() {
    echo ""
    echo "Operating System:"
    grep PRETTY_NAME /etc/os-release
}

check_disk() {
    echo ""
    echo "Disk Usage:"

    disk_usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

    echo "Usage: $disk_usage%"

    if [ "$disk_usage" -gt 80 ]; then
        echo "Status: WARNING - Disk usage is high"
    else
        echo "Status: NORMAL"
    fi
}

check_memory() {
    echo ""
    echo "Memory Usage:"

    memory_usage=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')

    echo "Usage: $memory_usage%"

    if [ "$memory_usage" -gt 80 ]; then
        echo "Status: WARNING - Memory usage is high"
    else
        echo "Status: NORMAL"
    fi
}

check_cpu() {
    echo ""
    echo "CPU Load:"

    cpu_load=$(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1)

    echo "1-Minute Load:$cpu_load"
}

check_uptime() {
    echo ""
    echo "System Uptime:"
    uptime
}

check_ssh() {
    echo ""
    echo "SSH Service:"

    if systemctl is-active --quiet ssh; then
        echo "Status: RUNNING"
    else
        echo "Status: STOPPED"
    fi
}

check_network() {
    echo ""
    echo "Network Connectivity:"

    if ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1; then
        echo "Status: CONNECTED"
    else
        echo "Status: NOT CONNECTED"
    fi
}

check_logs() {
    echo ""
    echo "Recent System Errors:"

    error_count=$(journalctl -p err -b --no-pager 2>/dev/null | wc -l)

    echo "Error Entries: $error_count"

    if [ "$error_count" -gt 0 ]; then
        echo "Status: ERRORS FOUND"
    else
        echo "Status: NO ERRORS"
    fi
}

full_health_check() {
    echo ""
    echo "===================================="
    echo "       LINUX SERVER HEALTH CHECK"
    echo "===================================="
    echo "Report Generated: $DATE"
    echo "===================================="

    check_hostname
    check_ip
    check_os
    check_disk
    check_memory
    check_cpu
    check_uptime
    check_ssh
    check_network
    check_logs

    echo ""
    echo "===================================="
    echo "       HEALTH CHECK COMPLETED"
    echo "===================================="
}

while true
do
    echo ""
    echo "===================================="
    echo "          LINUX ADMIN TOOL"
    echo "===================================="
    echo "1. Check Hostname"
    echo "2. Check IP Address"
    echo "3. Check Disk Usage"
    echo "4. Check Memory Usage"
    echo "5. Check CPU Load"
    echo "6. Check SSH Service"
    echo "7. Check Network"
    echo "8. Check System Logs"
    echo "9. Full Health Check"
    echo "10. Exit"
    echo "===================================="

    read -r -p "Enter your choice: " choice

    case $choice in
        1) check_hostname ;;
        2) check_ip ;;
        3) check_disk ;;
        4) check_memory ;;
        5) check_cpu ;;
        6) check_ssh ;;
        7) check_network ;;
        8) check_logs ;;
        9) full_health_check ;;
        10)
            echo "Exiting Linux Admin Tool..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter a number from 1 to 10."
            ;;
    esac
done

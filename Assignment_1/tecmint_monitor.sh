#!/bin/bash
# Tecmint Linux Server Monitor - Simplified Ubuntu Version

# Colors
green=$(tput setaf 2)
reset=$(tput sgr0)

echo -e "${green}===== SYSTEM INFORMATION =====${reset}"

# Internet connection
ping -c 1 google.com &> /dev/null && echo -e "${green}Internet:${reset} Connected" || echo -e "${green}Internet:${reset} Disconnected"

# OS & version
os_name=$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')
os_version=$(awk -F= '/^VERSION/{print $2}' /etc/os-release | tr -d '"')
echo -e "${green}Operating System:${reset} $os_name $os_version"

# Architecture
architecture=$(uname -m)
echo -e "${green}Architecture:${reset} $architecture"

# Kernel release
kernel=$(uname -r)
echo -e "${green}Kernel Release:${reset} $kernel"

# Hostname
echo -e "${green}Hostname:${reset} $HOSTNAME"

# Internal IP
internal_ip=$(hostname -I)
echo -e "${green}Internal IP:${reset} $internal_ip"

# External IP
if command -v dig &> /dev/null; then
    external_ip=$(dig +short myip.opendns.com @resolver1.opendns.com)
else
    external_ip="dig not installed"
fi
echo -e "${green}External IP:${reset} $external_ip"

# DNS Nameservers
dns=$(awk '/^nameserver/{print $2}' /etc/resolv.conf)
echo -e "${green}DNS Nameservers:${reset} $dns"

# Logged-in users
echo -e "${green}Logged-in Users:${reset}"
who

# RAM and Swap
echo -e "${green}Memory Usage:${reset}"
free -h

# Disk usage
echo -e "${green}Disk Usage:${reset}"
df -h --total | grep -E '^Filesystem|total'

# Load average
load_avg=$(uptime | awk -F'load average: ' '{print $2}')
echo -e "${green}Load Average:${reset} $load_avg"

# System uptime
uptime_info=$(uptime -p)
echo -e "${green}System Uptime:${reset} $uptime_info"

echo -e "${green}==============================${reset}"

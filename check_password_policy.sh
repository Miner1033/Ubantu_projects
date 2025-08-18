#!/bin/bash

# ----------------------------------------
# Check if the script is being run as root
# ----------------------------------------
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# ----------------------------------------
# Display the password policy from /etc/login.defs
# ----------------------------------------
echo "Password Policy (/etc/login.defs):"
echo "----------------------------------"
grep -E "PASS_MAX_DAYS|PASS_MIN_DAYS|PASS_MIN_LEN|PASS_WARN_AGE" /etc/login.defs

echo ""

# ----------------------------------------
# Display password complexity settings from /etc/security/pwquality.conf
# ----------------------------------------
echo "Password Complexity Settings (/etc/security/pwquality.conf):"
echo "----------------------------------"
if [ -f /etc/security/pwquality.conf ]; then
    grep -E "minlen|minclass" /etc/security/pwquality.conf
else
    echo "/etc/security/pwquality.conf file not found."
fi

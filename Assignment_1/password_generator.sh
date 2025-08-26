#!/bin/bash

# Function to display a header message
print_header() {
    echo "=========================================="
    echo "Welcome to the Secure Password Generator"
    echo "=========================================="
    echo ""
}

# Function to validate numeric input
validate_number() {
    local input=$1
    if ! [[ $input =~ ^[0-9]+$ ]]; then
        echo "Error: Please enter a valid positive number."
        return 1
    fi
    return 0
}

# Function to generate passwords
generate_passwords() {
    local length=$1
    local count=$2
    local passwords=()
    
    for ((i=0; i<count; i++)); do
        # Generate random bytes, convert to base64, and trim to desired length
        passwords+=("$(openssl rand -base64 48 | tr -d '\n' | cut -c1-"$length")")
    done
    
    echo "${passwords[@]}"
}

# Function to save passwords securely
save_passwords() {
    local passwords=("$@")
    local filename="passwords.txt.cpt"
    
    # Prompt for encryption passphrase
    echo ""
    echo "Please enter a passphrase to encrypt your passwords:"
    read -s passphrase
    echo "Please confirm your passphrase:"
    read -s passphrase_confirm
    
    # Verify passphrase
    if [ "$passphrase" != "$passphrase_confirm" ]; then
        echo "Error: Passphrases do not match. Passwords were not saved."
        return 1
    fi
    
    # Save and encrypt passwords
    printf "%s\n" "${passwords[@]}" | ccrypt -e -K "$passphrase" > "$filename"
    
    if [ $? -eq 0 ]; then
        echo "Passwords successfully encrypted and saved to $filename"
        echo "Important: Remember your passphrase to decrypt the file later."
    else
        echo "Error: Failed to save passwords."
        return 1
    fi
}

# Main script execution
clear
print_header

# Step 1: Get password length from user
echo "STEP 1: Please enter the desired length for your passwords:"
read -r PASS_LENGTH

# Validate input
if ! validate_number "$PASS_LENGTH"; then
    exit 1
fi

# Ensure minimum password length
if [ "$PASS_LENGTH" -lt 8 ]; then
    echo "Warning: For security, we recommend passwords of at least 8 characters."
    echo "Continue with $PASS_LENGTH characters? (y/n)"
    read -r confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        echo "Operation cancelled."
        exit 0
    fi
fi

# Step 2: Generate passwords
echo ""
echo "STEP 2: Generating secure passwords..."
passwords=()
while IFS= read -r line; do
    passwords+=("$line")
done < <(generate_passwords "$PASS_LENGTH" 3)

# Step 3: Display generated passwords
echo ""
echo "STEP 3: Here are your generated passwords:"
echo "----------------------------------------"
for i in "${!passwords[@]}"; do
    echo "$((i+1)). ${passwords[i]}"
done

# Step 4: Ask about saving passwords
echo ""
echo "STEP 4: Save options"
echo "Do you want to save these passwords to an encrypted file? (y/n)"
read -r choice

if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    save_passwords "${passwords[@]}"
else
    echo "Passwords were not saved."
fi

# Step 5: Final instructions
echo ""
echo "STEP 5: Instructions"
echo "If you saved your passwords, you can decrypt them later with:"
echo "ccrypt -d -K 'your_passphrase' passwords.txt.cpt"
echo ""
echo "Thank you for using the Secure Password Generator!"

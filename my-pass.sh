#!/bin/bash

# Usage: ./generate_password.sh <service_name>

if [ $# -ne 1 ]; then
    echo "Usage: $0 <service_name>"
    exit 1
fi

SERVICE_NAME="$1"
LENGTH=16  # Length of the generated password
ITERATIONS=100000  # High iteration count for PBKDF2 to make cracking harder

# The characters that are allowed in the password
ALLOWED_CHARS="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%"

# Prompt for the master password with hidden input
read -s -p "Enter your master password: " MASTER_PASSWORD
echo  # Add a new line after the password input

# Prompt for the salt with hidden input
read -s -p "Enter your salt: " SALT
echo  # Add a new line after the salt input

# Combine service name and master password with salt
COMBINED_INPUT="${SERVICE_NAME}${MASTER_PASSWORD}${SALT}"

# Use Python to generate a PBKDF2-hashed password
PASSWORD=$(python3 -c "
import hashlib
import binascii

# Define parameters
input_data = '${COMBINED_INPUT}'.encode('utf-8')
salt = b'${SALT}'
iterations = $ITERATIONS

# Generate PBKDF2 hash using SHA256
dk = hashlib.pbkdf2_hmac('sha256', input_data, salt, iterations)

# Convert the derived key to a hex string
password = binascii.hexlify(dk).decode('utf-8')

# Map the hex string to the allowed characters
allowed_chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%'
final_password = ''.join([allowed_chars[int(password[i:i+2], 16) % len(allowed_chars)] for i in range(0, len(password), 2)])

# Use the first 'LENGTH' characters of the mapped password
final_password = final_password[:$LENGTH]

print(final_password)
")

# Copy the password to the clipboard using xclip (requires xclip to be installed)
if command -v xclip > /dev/null; then
    echo -n "$PASSWORD" | xclip -selection clipboard
    echo "Password copied to clipboard!"
else
    echo "xclip is not installed. Please install it using 'sudo apt install xclip' or similar."
fi

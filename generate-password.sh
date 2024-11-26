#!/bin/bash

# Check if length argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <password_length>"
  exit 1
fi

# Ensure length is a positive integer
if ! [[ "$1" =~ ^[0-9]+$ ]] || [ "$1" -le 0 ]; then
  echo "Password length must be a positive integer."
  exit 1
fi

# Generate password using Node.js
node -e "
const crypto = require('crypto');
const symbols = '!@#$';
const length = $1;
if (length < 4) {
  console.error('Password length should be at least 4 for better security.');
  process.exit(1);
}
let chars = crypto.randomBytes(length - 1).toString('base64').replace(/[^a-zA-Z0-9]/g, '').slice(0, length - 1);
let symbol = symbols[Math.floor(Math.random() * symbols.length)];
let pos = Math.floor(Math.random() * (chars.length + 1));
console.log(chars.slice(0, pos) + symbol + chars.slice(pos));
"

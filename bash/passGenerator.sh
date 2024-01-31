#!/bin/bash
# you need to give this script two parameters the first is the length of the password the second is the alphapet and numbers you will need in the password

function generate_password() {
  local length="$1"
  local chars=""

  # Build character pool based on complexity requirements
  if [[ "$2" == "-l" ]]; then
    chars+="abcdefghijklmnopqrstuvwxyz"
  fi
  if [[ "$2" == "-u" ]]; then
    chars+="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  fi
  if [[ "$2" == "-d" ]]; then
    chars+="0123456789"
  fi
  if [[ "$2" == "-s" ]]; then
    chars+="!@#$%^&*()"
  fi

  # Ensure a diverse character pool for strong passwords
  if [[ ${#chars} -lt 3 ]]; then
    chars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()"
  fi

  # Generate the random password
  password=""
  for (( i = 0; i < length; i++ )); do
    password+="${chars:$RANDOM%${#chars}:1}"
  done

  echo "$password"
}

# Check for password length argument
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <password_length> [-l] [-u] [-d] [-s]"
  echo "  -l: Include lowercase letters"
  echo "  -u: Include uppercase letters"
  echo "  -d: Include digits"
  echo "  -s: Include symbols"
  exit 1
fi

# Generate and print the password
generate_password "$1" "${@:2}"


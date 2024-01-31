#!/bin/bash

# Check for required arguments
if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <domains_file> <iterations> <output_file>"
  exit 1
fi

domains_file="$1"
iterations="$2"
output_file="$3"

# Ensure tools are installed
required_tools=(amass findomain subfinder assetfinder httprobe subjack)
for tool in "${required_tools[@]}"; do
  if ! command -v "$tool" &> /dev/null; then
    echo "Error: Missing required tool '$tool'. Please install it."
    exit 1
  fi
done

# Function to enumerate subdomains using multiple tools
enumerate_domains() {
  domains=($@)
  all_subdomains=()

  for domain in "${domains[@]}"; do
    all_subdomains+=($(amass enum -d "$domain" | sort -u))
    all_subdomains+=($(findomain -t "$domain" | sort -u))
    all_subdomains+=($(subfinder -d "$domain" | sort -u))
    all_subdomains+=($(assetfinder --subs-only "$domain" | sort -u))
  done

  # Filter out non-resolvable subdomains
  resolved_subdomains=($(httprobe "${all_subdomains[@]}" | sort -u))

  # Check for potential subdomain takeovers
  echo "${resolved_subdomains[@]}" | subjack -w -t 50 | tee -a "$output_file"

  echo "${resolved_subdomains[@]}" | sort -u
}

# Read domains from file
domains=($(cat "$domains_file"))

# Perform iterations of subdomain enumeration
for i in $(seq 1 "$iterations"); do
  echo "Iteration $i:"
  subdomains=$(enumerate_domains "${domains[@]}")
  domains=("${subdomains[@]}")  # Update domains for the next iteration
done

# Save unique subdomains to output file and count them
echo "${domains[@]}" | sort -u > "$output_file"
subdomain_count=$(wc -l < "$output_file")

echo "Saved $subdomain_count unique subdomains to $output_file"

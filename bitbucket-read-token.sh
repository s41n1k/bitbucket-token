#!/bin/bash

# Colors
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# Banner
banner() {
    echo -e "${CYAN}"
    echo "  ____  _ _   _       _           _   _                 _     _       "
    echo " | __ )(_) |_| | __ _| |_ ___  __| | | |__   __ _ _ __ (_) __| | ___  "
    echo " |  _ \| | __| |/ _\` | __/ _ \/ _\` | | '_ \ / _\` | '_ \| |/ _\` |/ _ \ "
    echo " | |_) | | |_| | (_| | ||  __/ (_| | | | | | (_| | | | | | (_| |  __/ "
    echo " |____/|_|\__|_|\__,_|\__\___|\__,_| |_| |_|\__,_|_| |_|_|\__,_|\___| "
    echo "     Bitbucket Read Token Finder from JS Files - Author: x.com/s41n1k       "
    echo -e "${RESET}"
}

# Usage function
usage() {
    echo -e "${YELLOW}Usage: $0 -d domain.com -o outputDir/ [-s]${RESET}"
    exit 1
}

# Parse arguments
SILENT=false
while getopts ":d:o:s" opt; do
    case $opt in
        d) DOMAIN="$OPTARG" ;;
        o) OUTPUT_DIR="$OPTARG" ;;
        s) SILENT=true ;;
        *) usage ;;
    esac
done

# Check for required arguments
if [ -z "$DOMAIN" ] || [ -z "$OUTPUT_DIR" ]; then
    usage
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Temporary files
JS_LIST_FILE="$OUTPUT_DIR/js_links.txt"
TOKEN_OUTPUT_FILE="$OUTPUT_DIR/js_with_tokens.txt"
FINAL_TOKENS_FILE="$OUTPUT_DIR/final_tokens.txt"

# Display banner if not silent
if [ "$SILENT" = false ]; then
    banner
fi

# Collect URLs using waybackurls and gau
if [ "$SILENT" = false ]; then
    echo -e "${CYAN}[*] Collecting JS URLs...${RESET}"
fi
waybackurls "$DOMAIN" | grep "\.js$" > "$JS_LIST_FILE"
gau "$DOMAIN" | grep "\.js$" >> "$JS_LIST_FILE"
sort -u "$JS_LIST_FILE" -o "$JS_LIST_FILE"

# Scan JS files for the BITBUCKET_READ_TOKEN
if [ "$SILENT" = false ]; then
    echo -e "${CYAN}[*] Scanning JS files for 'BITBUCKET_READ_TOKEN'...${RESET}"
fi
> "$TOKEN_OUTPUT_FILE" # Clear the output file

while IFS= read -r JS_URL; do
    if [ "$SILENT" = false ]; then
        echo -e "${YELLOW}[~] Scanning: $JS_URL${RESET}"
    fi
    RESPONSE=$(curl -s "$JS_URL")
    if echo "$RESPONSE" | grep -q "BITBUCKET_READ_TOKEN"; then
        TOKEN=$(echo "$RESPONSE" | grep -oP 'BITBUCKET_READ_TOKEN\s*:\s*".*?"')
        if [ -n "$TOKEN" ]; then
            if [ "$SILENT" = false ]; then
                echo -e "${GREEN}[+] Found token in $JS_URL${RESET}"
            fi
            echo "$JS_URL" >> "$TOKEN_OUTPUT_FILE"
            echo " $TOKEN" >> "$TOKEN_OUTPUT_FILE"
            echo "" >> "$TOKEN_OUTPUT_FILE"
        fi
    fi
done < "$JS_LIST_FILE"

# Remove duplicate tokens
awk '!seen[$0]++ && /BITBUCKET_READ_TOKEN/' "$TOKEN_OUTPUT_FILE" > "$FINAL_TOKENS_FILE"

# Final output
if [ "$SILENT" = false ]; then
    echo -e "${CYAN}[*] Scan completed. Results saved to:${RESET}"
    echo -e "${YELLOW} - All results: $TOKEN_OUTPUT_FILE${RESET}"
    echo -e "${YELLOW} - Unique tokens: $FINAL_TOKENS_FILE${RESET}"
fi

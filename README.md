# 🛠️ Bitbucket Read Token Finder

>🔍 Find and Extract BITBUCKET_READ_TOKEN from JavaScript Files Effortlessly!

## 📖 Overview
*This script is a tool for security enthusiasts and researchers to:*

1. Identify JavaScript files related to a domain using tools like `waybackurls` and `gau`.
2. Scan these JavaScript files for the presence of `BITBUCKET_READ_TOKEN`.
3. Save results in a structured and organized format, ensuring duplicate tokens are removed.

## ✨ Features
🕵️ Automatic JS Collection: Collects .js file links from Wayback Machine and GAU.\
🔎 Precise Scanning: Searches exclusively for BITBUCKET_READ_TOKEN within JS files.\
🔇 Silent Mode: Run scans quietly with the -s option.\
🧹 Duplicate Removal: Filters out duplicate tokens for a clean result.\
📂 Organized Output: Saves results in separate files for full and unique tokens.


## 🚀 Usage
Pre-requisites
Ensure the following tools are installed:

- waybackurls
- gau
- curl

Install them via:
```
go install github.com/tomnomnom/waybackurls@latest
go install github.com/lc/gau/v2/cmd/gau@latest
sudo apt install curl  # Or equivalent for your package manager
```

## Command
``` bash bitbucket_token_finder.sh -d <domain> -o <output_directory> [-s] ```

## Options
```
Flag	Description
-d	The target domain to scan for JS files.	-d example.com
-o	Output directory to save results.	-o ./results/
-s	Enable silent scan mode (no output display).	-s (optional)
```
## 📂 Output
### Files Generated
1. `js_links.txt:`
  - Contains all collected JavaScript file links.
2. `js_with_tokens.txt:`
  - Contains JS file links and their detected BITBUCKET_READ_TOKEN.
3. `final_tokens.txt:`
  - A deduplicated list of BITBUCKET_READ_TOKEN and their JS file links.

## Sample Output
`final_tokens.txt`
```
https://example.com/js/main.js
 BITBUCKET_READ_TOKEN: "ATCTT3xFfGN0-TOKEN-HERE"

https://example.com/assets/script.js
 BITBUCKET_READ_TOKEN: "ATCTT3xFfGN0-ANOTHER-TOKEN"
```
## 🔧 Examples
  ### Basic Scan
`bash bitbucket_token_finder.sh -d example.com -o ./results/`
  ### Silent Scan
`bash bitbucket_token_finder.sh -d example.com -o ./results/ -s`

## 🛡️ Disclaimer
This tool is intended for ethical use and research purposes only. Unauthorized scanning or misuse of this tool is prohibited. Always ensure you have the necessary permissions before targeting any domain.

## 🖼️ Demo
![bitbucket scan](https://github.com/user-attachments/assets/90c2145a-77a1-4f8c-904c-de0e612c14fd)

# ✍️ Author
- **Name:** *s41n1k*
- **Twitter:** [@s41n1k](https://x.com/s41n1k)

# **Thank you**


## 📃 License
This project is licensed under the MIT License. See the LICENSE file for details.

## 🛠️ Contributions
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

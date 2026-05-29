#!/bin/bash

# Script to automate CSR generation with EKU support
# Prompts for CN and stores results in a timestamped directory

echo "--- mTLS CSR Generation Utility ---"

ATTRIBUTES_FILE="attributes.toml"

# Prompt for Common Name
read -p "Enter the Common Name (CN) for the certificate: " CN
read -p "Enter the email address: " EMAIL

# Create timestamped directory
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
mkdir -p "$CN" # create directory for this CN if it doesn't exist
mkdir -p "$CN/$TIMESTAMP" # create timestamped directory
DIR="$CN/$TIMESTAMP"

echo "Creating configuration file..."
cat <<EOF > "$DIR/$CN.cnf.template"
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
req_extensions = req_ext

[dn]
{{CONTENT_HERE}}
CN = $CN
emailAddress = $EMAIL

[req_ext]
subjectAltName = @alt_names
extendedKeyUsage = clientAuth, serverAuth

[alt_names]
DNS.1 = $CN
EOF

echo "Replacing placeholders..."
sed -e '/{{CONTENT_HERE}}/{r $ATTRIBUTES_FILE' -e 'd}' "$DIR/$CN.cnf.template" > "$DIR/$CN.cnf"

#python3 - "$DIR/$CN.cnf" "$ATTRIBUTES_FILE" <<'PY'
#from pathlib import Path
#import sys#

#config_path = Path(sys.argv[1])
#attributes_path = Path(sys.argv[2])
#config = config_path.read_text()
#attributes = attributes_path.read_text().rstrip("\n")
#config_path.write_text(config.replace("<<ATTRIBUTES>>", attributes))
#PY

echo "Generating private key and CSR..."
openssl req -new -keyout "$DIR/$CN.key" -out "$DIR/$CN.csr" -config "$DIR/$CN.cnf"

echo "----------------------------------"
echo "Success!"
echo "Files generated in: $DIR/"
echo " - $DIR/$CN.key"
echo " - $DIR/$CN.csr"
echo "-----------------------------------"

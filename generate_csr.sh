#!/bin/bash

set -euo pipefail
umask 077

# Script to automate CSR generation with EKU support
# Prompts for CN and stores results in a timestamped directory

echo "--- mTLS CSR Generation Utility ---"

if ! command -v openssl &> /dev/null; then
    echo "Error: openssl is required but not installed." >&2
    exit 1
fi

ATTRIBUTES_FILE="attributes.toml"
if [ ! -f "$ATTRIBUTES_FILE" ]; then
    echo "Error: $ATTRIBUTES_FILE not found!" >&2
    exit 1
fi

# Define Variables
ATTRIBUTES=$(<"$ATTRIBUTES_FILE")
CERTS_STAGING_FOLDER="outputs"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
PASSPHRASE=$(tr -dc 'A-Za-z0-9!@#$&()' < /dev/urandom | head -c 20) # Random 20 Character Passphrase for Private Key encryption (optional, can be removed if not needed)

# Prompt for Common Name
read -r -p "Enter the Common Name (CN) for the certificate: " CN
read -r -p "Enter the email address: " EMAIL

if [[ -z "$CN" || -z "$EMAIL" ]]; then
    echo "Error: Common Name and Email cannot be empty." >&2
    exit 1
fi

# Create timestamped directory
DIR="$CERTS_STAGING_FOLDER/$CN/$TIMESTAMP"
mkdir -p "$DIR"

echo "Creating configuration file..."
cat <<EOF > "$DIR/$CN.cnf"
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
req_extensions = req_ext

[dn]
$ATTRIBUTES
CN = $CN
emailAddress = $EMAIL

[req_ext]
subjectAltName = @alt_names
extendedKeyUsage = clientAuth, serverAuth

[alt_names]
DNS.1 = $CN
EOF

echo "Generating private key and CSR ..."
openssl req -new -keyout "$DIR/$CN.key" -out "$DIR/$CN.csr" -config "$DIR/$CN.cnf" -passout pass:$PASSPHRASE

echo "---------------------------"
echo "CSR and Private Key generated successfully!"
echo "Files generated in       : $DIR/"
echo " - $DIR/$CN.key"
echo " - $DIR/$CN.csr"
echo "Private Key (Passphrase) : $PASSPHRASE"
echo "*** Store the passphrase securely, it is required to use the private key! ***"
echo "-----------------------------------"

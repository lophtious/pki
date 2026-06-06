#!/bin/bash

# Generate CSR (Certificate Signing Request) using OpenSSL with EKU (Extended Key Usage) support for mTLS (Mutual TLS) authentication. 

echo "--------------------------------------------------"
echo "---         mTLS CSR Generation Utility        ---"
echo "--------------------------------------------------"
echo ""

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

# Get CN from argument or prompt
CN=$1

if [ -z "$CN" ]; then
    read -r -p "Enter the (Common Name (CN) | DNS Name) for the certificate: " CN
fi

# Create timestamped directory
DIR="$CERTS_STAGING_FOLDER/$CN/$TIMESTAMP"
mkdir -p "$DIR"

echo "... creating configuration file"

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

[req_ext]
subjectAltName = @alt_names
extendedKeyUsage = clientAuth, serverAuth

[alt_names]
DNS.1 = $CN
EOF

echo "... generating (encrypted) Private Key and CSR ..."
echo ""
openssl req -new -keyout "$DIR/$CN.key" -out "$DIR/$CN.csr" -config "$DIR/$CN.cnf" -passout pass:$PASSPHRASE
echo ""

echo "--------------------------------------------------"
echo "   CSR and Private Key generated successfully!"
echo "--------------------------------------------------"
echo "Files generated in       : $DIR/"
echo " - $DIR/$CN.key"
echo " - $DIR/$CN.csr"
echo "Private Key (Passphrase) : $PASSPHRASE"
echo "--------------------------------------------------"
echo "*** Store the Private Key PASSPHRASE securely ***"
echo "--------------------------------------------------"


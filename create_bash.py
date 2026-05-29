# Create a bash script that automates the CSR generation process
bash_script = """#!/bin/bash

# Script to automate CSR generation with EKU support
# Prompts for CN and stores results in a timestamped directory

echo "--- mTLS CSR Generation Utility ---"

# Prompt for Common Name
read -p "Enter the Common Name (CN) for the certificate: " CN
read -p "Enter the email address: " EMAIL

# Create timestamped directory
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
DIR="csr_$TIMESTAMP"
mkdir -p "$DIR"

echo "Creating configuration file..."
cat <<EOF > "$DIR/req.cnf"
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
req_extensions = req_ext

[dn]
C = US
ST = State
L = City
O = Organization
OU = Department
CN = $CN
emailAddress = $EMAIL

[req_ext]
subjectAltName = @alt_names
extendedKeyUsage = clientAuth, serverAuth

[alt_names]
DNS.1 = $CN
EOF

echo "Generating private key and CSR..."
openssl req -new -keyout "$DIR/private.key" -out "$DIR/request.csr" -config "$DIR/req.cnf"

echo "-----------------------------------"
echo "Success!"
echo "Files generated in: $DIR/"
echo " - $DIR/private.key"
echo " - $DIR/request.csr"
echo "-----------------------------------"
"""

with open("generate_csr.sh", "w") as f:
    f.write(bash_script)
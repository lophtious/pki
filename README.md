# CSR Generation Guide for mTLS with EKU Support

This document outlines the steps to generate a Certificate Signing Request (CSR) configured for mutual TLS (mTLS), including specific Extended Key Usage (EKU) attributes, for submission to DigiCert.

## Prerequisites
* OpenSSL installed on your system.
* Access to your DigiCert CertCentral account.

## Step 1: Create the Configuration File (`req.cnf`)
Create a file named `req.cnf`. This ensures the CSR contains the necessary extensions for mTLS.

```ini
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
CN = your-server-name.example.com

[req_ext]
subjectAltName = @alt_names
extendedKeyUsage = clientAuth, serverAuth

[alt_names]
DNS.1 = your-server-name.example.com

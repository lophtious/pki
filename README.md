# Generate CSR for mTLS with EKU Support

CSR (Certificate Signing Request) generation for mutual TLS (mTLS) with Extended Key Usage (EKU) attributes.
The included `generate_csr.sh` script builds a CSR and private key using OpenSSL, while `attributes.toml` provides the default certificate attributes. Mutual TLS (mTLS) requires at minimumum 'clientAuth' or 'serverAuth' EKUs.

## Pre-Requisites

* Bash (Linux/MacOS/Unix)
* OpenSSL (https://www.openssl.org/)
* Ensure the script has the 'Execute' permission set.

```bash
chmod +x generate_csr.sh`)
```

## Files

* `generate_csr.sh` — automation script that prompts for certificate details and generates a CSR
* `attributes.toml` — default DN attributes used when creating the OpenSSL config
* `outputs/` — generated CSR, key, and config files are saved here

## Usage
1. Update `attributes.toml` with your organization details if needed:

    ```toml
    C = US
    ST = State
    L = City
    O = Company, LLC.
    OU = Department
    ```

2. Run the script:
    ```bash
    ./generate_csr.sh
    ```

3. Enter the requested values:

    * Common Name (CN)
    * Email address

4. The script creates a timestamped directory under `outputs/<CN>/<timestamp>/` and writes:

    * `<CN>.cnf`
    * `<CN>.key` (encrypted with an auto-generated passphrase)
    * `<CN>.csr`

5. The console output will display the passphrase used to encrypt the private key. Store it securely, as it is required to use the private key.

## What is included in the CSR config

The generated OpenSSL config enables the following extensions:

* `subjectAltName` with a DNS entry matching the supplied CN
* `extendedKeyUsage = clientAuth, serverAuth`

## Notes

* The script generates a new private key and CSR in one step. 
* The private key is encrypted with a randomly generated 20-character passphrase.
* If you need a different DN layout, update `attributes.toml` before running the script.
* The generated config file includes values from `attributes.toml`, the supplied CN, and the provided email address.

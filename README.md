# CSR Generation Guide for mTLS with EKU Support

This repository automates CSR generation for mutual TLS (mTLS) with Extended Key Usage (EKU) attributes.
The included `generate_csr.sh` script builds a CSR and private key using OpenSSL, while `attributes.toml` provides the default distinguished name values.

## Prerequisites
* Bash shell
* OpenSSL installed
* Execute permission on `generate_csr.sh` (`chmod +x generate_csr.sh`)

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
    * `<CN>.cnf.template`
    * `<CN>.cnf`
    * `<CN>.key`
    * `<CN>.csr`

## What is included in the CSR config
The generated OpenSSL config enables the following extensions:
* `subjectAltName` with a DNS entry matching the supplied CN
* `extendedKeyUsage = clientAuth, serverAuth`

## Notes
* The script generates a new key and CSR in one step.
* If you need a different DN layout, update `attributes.toml` before running the script.
* The generated config file includes values from `attributes.toml`, the supplied CN, and the provided email address.

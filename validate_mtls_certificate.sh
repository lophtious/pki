#!/bin/bash

openssl x509 -in your-certificate.crt -text -noout | grep -A 1 "Extended Key Usage"
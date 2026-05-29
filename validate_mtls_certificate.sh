#!/bin/bash

openssl x509 -in $1.crt -text -noout | grep -A 1 "Extended Key Usage"
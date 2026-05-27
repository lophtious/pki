#!/bin/bash

openssl x509 -in $1.pem -text -noout | grep -A 1 "Extended Key Usage"
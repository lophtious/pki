#!/bin/bash

openssl req -new -keyout $1.key -out $1.csr -config $1.cnf

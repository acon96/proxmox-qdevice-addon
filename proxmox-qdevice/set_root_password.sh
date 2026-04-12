#!/bin/bash

# Set root password if NEW_ROOT_PASSWORD environment variable is set
if [ ! -z "${NEW_ROOT_PASSWORD+x}" ]; then
  echo "root:${NEW_ROOT_PASSWORD}" | chpasswd
  echo "Root password has been set"
else
  echo "No root password specified, skipping..."
fi
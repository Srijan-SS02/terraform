#!/bin/bash

# CAPI
echo "Downloading Kubernetes CAPI Image Builder..."
curl -L https://github.com/kubernetes-sigs/image-builder/tarball/main -o image-builder.tgz
mkdir image-builder
tar xzf image-builder.tgz --strip-components 1 -C image-builder
rm image-builder.tgz
cd image-builder/images/capi

# Install dependencies
echo "Installing Packer and Ansible"
make deps
export PATH=$PWD/.bin:$PATH
echo "Installing dependencies..."
make deps-azure

# Set environment variables
export AZURE_SUBSCRIPTION_ID="$(grep '^AZURE_SUBSCRIPTION_ID=' .env | cut -d '=' -f2-)"
export AZURE_CLIENT_ID="$(grep '^AZURE_CLIENT_ID=' .env | cut -d '=' -f2-)"
export AZURE_CLIENT_SECRET="$(grep '^AZURE_CLIENT_SECRET=' .env | cut -d '=' -f2-)"

# Building Images
echo "Building images for Azure..."
make build-azure-sig-ubuntu-2204

echo "Retrieving image references..."
echo "Ubuntu 22.04: $(make build-azure-sig-ubuntu-2204 | grep -o 'SharedImageGallery:[^ ]*')" > image_references.txt

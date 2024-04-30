#!/bin/bash

# CAPI
echo "Downloading Kubernetes CAPI Image Builder..."
curl -L https://github.com/kubernetes-sigs/image-builder/tarball/main -o image-builder.tgz
mkdir image-builder
tar xzf image-builder.tgz --strip-components 1 -C image-builder
rm image-builder.tgz
cd image-builder/images/capi

# Install dependencies
echo "Installing dependencies..."
make deps-azure

# Add more build targets as needed Azure
echo "Building images for Azure..."
make build-azure-sig-ubuntu-1804
make build-azure-sig-ubuntu-2004
make build-azure-sig-windows-2019

echo "Retrieving image references..."
echo "Ubuntu 18.04: $(make build-azure-sig-ubuntu-1804 | grep -o 'SharedImageGallery:[^ ]*')" > image_references.txt
echo "Ubuntu 20.04: $(make build-azure-sig-ubuntu-2004 | grep -o 'SharedImageGallery:[^ ]*')" >> image_references.txt
echo "Windows 2019: $(make build-azure-sig-windows-2019 | grep -o 'SharedImageGallery:[^ ]*')" >> image_references.txt


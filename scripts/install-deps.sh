#!/bin/bash

# Dependency Installation Helper
# Fixes common dependency issues for Ubuntu systems

set -e

echo "=== Installing Dependencies for Local AI Setup ==="

# Update package list
echo "Updating package list..."
sudo apt update

# Install core dependencies
echo "Installing core dependencies..."
sudo apt install -y git build-essential cmake wget curl

# Install netcat (handle virtual package)
echo "Installing netcat..."
if ! command -v nc >/dev/null 2>&1; then
    echo "Netcat not found, installing netcat-openbsd..."
    sudo apt install -y netcat-openbsd
fi

# Install other dependencies
echo "Installing additional dependencies..."
sudo apt install -y bc jq

# Verify installations
echo ""
echo "=== Verifying Installations ==="
for cmd in git cmake wget curl nc bc jq; do
    if command -v "$cmd" >/dev/null 2>&1; then
        echo "✓ $cmd: $(command -v "$cmd")"
    else
        echo "✗ $cmd: Not found"
    fi
done

echo ""
echo "=== Installation Complete ==="
echo "You can now run: ./install.sh"

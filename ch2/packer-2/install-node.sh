#!/usr/bin/env bash

set -euo pipefail

# Verify that curl is already available
command -v curl

# Download NodeSource setup script for Node.js 24
curl -fsSL https://rpm.nodesource.com/setup_24.x \
  -o /tmp/nodesource_setup.sh

# Configure NodeSource repository
sudo bash /tmp/nodesource_setup.sh

# Install Node.js
sudo dnf install -y nodejs

# Verify installation
node --version
npm --version

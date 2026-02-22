#!/bin/bash
# install_fluentd.sh
# This script installs Fluentd (fluent-package) on Amazon Linux and the OpenSearch plugin.

set -e

echo "Starting Fluentd installation..."

# 1. Add Fluentd Repository (Amazon Linux)
curl -fsSL https://toolbelt.treasuredata.com/sh/install-amazon2-fluent-package.sh | sh

# 2. Start and Enable Fluentd
echo "Starting and enabling fluent-package service..."
systemctl start fluent-package
systemctl enable fluent-package

# 3. Install OpenSearch Plugin
echo "Installing fluent-plugin-opensearch..."
/usr/sbin/fluent-gem install fluent-plugin-opensearch

# 4. Permissions for /var/log/messages
echo "Setting permissions for /var/log/messages..."
chmod 644 /var/log/messages
usermod -a -G root _fluentd 

echo "Fluentd installation successfully complete."

#!/usr/bin/env bash

cd /vagrant

echo "=== Updating apt..."
apt-get update >/dev/null 2>&1

#!/usr/bin/env bash

echo "=== Starting provision script..."

cd /vagrant

echo "=== Setting password for user ubuntu to ubuntu"

echo "ubuntu:ubuntu" | chpasswd

echo "=== Updating apt..."
apt-get update >/dev/null 2>&1

# Used in many dependencies:
apt-get install python-software-properties curl git -y

#!/bin/bash

# Update package lists
echo "Updating package lists..."
yum -q update &> /dev/null

# Upgrade installed packages (includes potential removals and reinstalls)
echo "Upgrading installed packages..."
yum -y upgrade &> /dev/null

# Clean up the system
echo "Cleaning up..."
yum -y clean all &> /dev/null

echo "Update process complete!"

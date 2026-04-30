#!/bin/bash
# api-blsheet/scripts/after_install.sh
# Runs AFTER new files are copied to the instance.
# Installs production npm dependencies.

exec >> /home/ec2-user/app/logs/deploy.log 2>&1
echo "===== AfterInstall: $(date) ====="

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
export PATH="/usr/local/bin:$PATH"

cd /home/ec2-user/app

echo "Node version: $(node --version)"
echo "NPM version:  $(npm --version)"
echo "Installing production dependencies..."

npm install --omit=dev

echo "Installed. node_modules size: $(du -sh node_modules | cut -f1)"
echo "AfterInstall complete."

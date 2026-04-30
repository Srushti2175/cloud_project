#!/bin/bash
# api-blsheet/scripts/start_server.sh
# Starts the Node.js app with PM2.

exec >> /home/ec2-user/app/logs/deploy.log 2>&1
echo "===== ApplicationStart: $(date) ====="

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
export PATH="/usr/local/bin:$PATH"

cd /home/ec2-user/app

echo "Starting blsheet-api with PM2..."

pm2 start dist/server.js \
  --name blsheet-api \
  --log /home/ec2-user/app/logs/app.log \
  --merge-logs \
  --restart-delay=3000 \
  --max-restarts=5

# Save PM2 process list so it survives reboots
pm2 save

echo "PM2 process list:"
pm2 list

echo "ApplicationStart complete."

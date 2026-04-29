#!/bin/bash
set -e

source /etc/profile
export PATH=$PATH:/usr/local/bin

cd /home/ec2-user/app   # ✅ correct path

pm2 delete all || true

# start app using PM2 (correct way)
pm2 start "npx tsx api/index.ts" --name blsheet-backend

pm2 save

exit 0

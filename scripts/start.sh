#!/bin/bash
set -e

# ✅ ensure pm2 is available
export PATH=$PATH:/usr/local/bin

cd /home/ec2-user/app/api-blsheet

pm2 delete all || true

# start app
pm2 start "npx tsx api/index.ts" --name blsheet-backend --no-autorestart

pm2 save

# exit cleanly
exit 0

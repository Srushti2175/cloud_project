#!/bin/bash
# Ensure log directory exists
mkdir -p /home/ubuntu/api-blsheet/logs
exec >> /home/ubuntu/api-blsheet/logs/deploy.log 2>&1

echo "===== ApplicationStart: $(date) ====="

# 1. Load Node/NVM environment
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
cd /home/ubuntu/api-blsheet

echo "Fetching SecureSecrets from AWS SSM..."

# 2. Fetch and Export every secret
# NOTE: We use --with-decryption because these are SecureStrings
export MONGO_URL=$(aws ssm get-parameter --name "/blsheet/DB_URL" --with-decryption --query Parameter.Value --output text --region ap-south-1)
export ACCESS_TOKEN_SECRET=$(aws ssm get-parameter --name "/blsheet/ACCESS_TOKEN_SECRET" --with-decryption --query Parameter.Value --output text --region ap-south-1)
export SESSION_SECRET_KEY=$(aws ssm get-parameter --name "/blsheet/SESSION_SECRET_KEY" --with-decryption --query Parameter.Value --output text --region ap-south-1)
export MAIL_PASSWORD=$(aws ssm get-parameter --name "/blsheet/MAIL_PASSWORD" --with-decryption --query Parameter.Value --output text --region ap-south-1)
export GOOGLE_CLIENT_ID=$(aws ssm get-parameter --name "/blsheet/GOOGLE_CLIENT_ID" --with-decryption --query Parameter.Value --output text --region ap-south-1)
export GOOGLE_CLIENT_SECRET=$(aws ssm get-parameter --name "/blsheet/GOOGLE_CLIENT_SECRET" --with-decryption --query Parameter.Value --output text --region ap-south-1)
export CLOUD_NAME=$(aws ssm get-parameter --name "/blsheet/CLOUD_NAME" --with-decryption --query Parameter.Value --output text --region ap-south-1)
export CLOUD_API_KEY=$(aws ssm get-parameter --name "/blsheet/CLOUD_API_KEY" --with-decryption --query Parameter.Value --output text --region ap-south-1)
export CLOUD_API_SECRET=$(aws ssm get-parameter --name "/blsheet/CLOUD_API_SECRET" --with-decryption --query Parameter.Value --output text --region ap-south-1)
export OPEN_AI_KEY=$(aws ssm get-parameter --name "/blsheet/OPEN_AI_KEY" --with-decryption --query Parameter.Value --output text --region ap-south-1)
export OPENROUTER_API_KEY=$(aws ssm get-parameter --name "/blsheet/OPENROUTER_API_KEY" --with-decryption --query Parameter.Value --output text --region ap-south-1)

# 3. Infrastructure Variables
export ALB_DNS=$(aws ssm get-parameter --name "/blsheet/ALB_DNS" --query Parameter.Value --output text --region ap-south-1)
export PORT=5555
export NODE_ENV=production

echo "Starting Application with PM2..."

# 4. Start the app. --update-env is CRITICAL to push these new secrets into the app
pm2 delete blsheet-api || true
pm2 start dist/server.js --name blsheet-api --update-env

pm2 save
echo "ApplicationStart complete. Check logs/app.log for app status."
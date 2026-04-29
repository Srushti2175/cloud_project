#!/bin/bash
set -e

source /etc/profile
export PATH=$PATH:/usr/local/bin

cd /home/ec2-user/app

npm install

# install globally for runtime
npm install -g tsx
npm install -g pm2

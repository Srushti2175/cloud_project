#!/bin/bash
set -e

cd /home/ec2-user/app

npm install

npm install -g tsx
npm install -g pm2

export PATH=$PATH:/usr/local/bin

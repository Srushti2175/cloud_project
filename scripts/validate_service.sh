#!/bin/bash
# api-blsheet/scripts/validate_service.sh
# Called by CodeDeploy after ApplicationStart.
# Must exit 0 for the deployment to be marked successful.
# If this fails, CodeDeploy auto-rolls back to the previous version.

exec >> /home/ec2-user/app/logs/deploy.log 2>&1
echo "===== ValidateService: $(date) ====="

MAX_RETRIES=12   # 12 x 5 seconds = 60 seconds total wait
RETRY_INTERVAL=5
PORT=5555

echo "Waiting for server to respond on port $PORT..."

for i in $(seq 1 $MAX_RETRIES); do
  HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT/health 2>/dev/null)

  if [ "$HTTP_STATUS" = "200" ]; then
    echo "Health check passed! Server responded with HTTP $HTTP_STATUS on attempt $i."
    echo "ValidateService complete — deployment SUCCESSFUL."
    exit 0
  fi

  echo "Attempt $i/$MAX_RETRIES — got HTTP $HTTP_STATUS, retrying in ${RETRY_INTERVAL}s..."
  sleep $RETRY_INTERVAL
done

echo "ERROR: Server did not respond with 200 after $MAX_RETRIES attempts."
echo "Last PM2 logs:"
export PATH="/usr/local/bin:$PATH"
pm2 logs blsheet-api --lines 30 --nostream 2>/dev/null || true
echo "ValidateService FAILED — CodeDeploy will roll back."
exit 1

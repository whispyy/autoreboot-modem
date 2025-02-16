#!/bin/bash

# Configurable Variables
ROUTER_IP="192.168.0.1"
USERNAME="cusadmin"
PASSWORD="**"
LOG_FILE="logs/reboot_log_$(date +"%Y-%m-%d_%H-%M-%S").log"

# Clear previous logs
echo "----- Reboot Execution Log -----" > "$LOG_FILE"
echo "Date: $(date)" >> "$LOG_FILE"

echo "1️⃣ Logging in to router..."
LOGIN_RESPONSE=$(curl -s "http://$ROUTER_IP/1/Device/Users/Login" \
  -H "Accept: */*" \
  -H "Accept-Language: en-US,en;q=0.9,fr;q=0.8" \
  -H "Connection: keep-alive" \
  -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" \
  -H "Origin: http://$ROUTER_IP" \
  -H "Referer: http://$ROUTER_IP/webpages/login.html" \
  -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36" \
  -H "X-Requested-With: XMLHttpRequest" \
  --data-urlencode "model={\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\"}" \
  --cookie-jar cookies.txt \
  --insecure)

if echo "$LOGIN_RESPONSE" | grep -q '"errCode":"000"'; then
  echo "✅ Login successful" | tee -a "$LOG_FILE"
else
  echo "❌ Login failed. Response: $LOGIN_RESPONSE" | tee -a "$LOG_FILE"
  exit 1
fi

echo "2️⃣ Retrieving CSRF token..."
CSRF_TOKEN=$(curl -s "http://$ROUTER_IP/1/Device/Users/CSRF" \
  -H "Accept: application/json, text/javascript, */*; q=0.01" \
  -H "Accept-Language: en-US,en;q=0.9,fr;q=0.8" \
  -H "Connection: keep-alive" \
  -H "Referer: http://$ROUTER_IP/webpages/index.html" \
  -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36" \
  -H "X-Requested-With: XMLHttpRequest" \
  -b cookies.txt \
  --insecure | sed -E 's/.*"CSRF":"([^"]+)".*/\1/')

if [[ -z "$CSRF_TOKEN" ]]; then
  echo "❌ Failed to retrieve CSRF token." | tee -a "$LOG_FILE"
  exit 1
else
  echo "✅ Extracted CSRF Token: $CSRF_TOKEN" | tee -a "$LOG_FILE"
fi

echo "3️⃣ Executing reboot command..."
REBOOT_RESPONSE=$(curl -s "http://$ROUTER_IP/1/Device/CM/Reboot" \
  -H "Accept: application/json, text/javascript, */*; q=0.01" \
  -H "Accept-Language: en-US,en;q=0.9" \
  -H "Connection: keep-alive" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Origin: http://$ROUTER_IP" \
  -H "Referer: http://$ROUTER_IP/webpages/index.html" \
  -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36" \
  -H "X-Requested-With: XMLHttpRequest" \
  -b cookies.txt \
  --data-urlencode "model={\"reboot\":\"1\"}" \
  --data-urlencode "csrf=$CSRF_TOKEN" \
  --insecure)

if echo "$REBOOT_RESPONSE" | grep -q '"errCode":"000"'; then
  echo "✅ Reboot triggered successfully!" | tee -a "$LOG_FILE"
else
  echo "❌ Reboot failed. Response: $REBOOT_RESPONSE" | tee -a "$LOG_FILE"
  exit 1
fi

echo "🔄 Router reboot initiated. Please wait a few minutes." | tee -a "$LOG_FILE"

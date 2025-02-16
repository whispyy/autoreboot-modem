#!/bin/bash

WEBSITES=("google.com" "github.com" "cloudflare.com")
RETRY_COUNT=3

take_action() {
    echo "All websites are unreachable! Taking action..."
    local attempt=1
    while [ $attempt -le $RETRY_COUNT ]; do
        echo "Attempt $attempt of $RETRY_COUNT"
        ./reboot_router.sh && return
        ((attempt++))
        sleep 10  # Wait before retrying
    done
    echo "Failed to execute take_action after $RETRY_COUNT attempts."
}

fail_count=0

for site in "${WEBSITES[@]}"; do
    if ! ping -c 3 -W 2 "$site" > /dev/null 2>&1; then
        ((fail_count++))
    fi
done

if [ "$fail_count" -eq "${#WEBSITES[@]}" ]; then
    take_action
fi

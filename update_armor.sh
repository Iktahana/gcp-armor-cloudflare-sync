#!/bin/bash

# --- Use environment variables with fallbacks ---
# ${VAR:-default} means: if VAR is unset, use default
PROJECT_ID="${PROJECT_ID}"
POLICY_NAME="${POLICY_NAME}"
RULE_PRIORITY="${RULE_PRIORITY:-100}"

echo "----------------------------------------------------------"
echo "🚀 Starting Cloud Armor Rule Update..."
echo "----------------------------------------------------------"

# 1. Fetch latest Cloudflare IP ranges
echo "📥 Fetching IPv6 ranges from Cloudflare..."

IPV6=$(curl -s https://www.cloudflare.com/ips-v6)

if [ -z "$IPV6" ]; then
    echo "❌ Error: Could not fetch IP ranges. Check your internet connection."
    exit 1
fi

# 2. Combine and format IPs into a comma-separated string
# This joins all lines with commas
ALL_IPS=$(echo -e "$IPV6" | paste -sd "," -)

echo "Successfully fetched IPs."
echo "Updating Security Policy: [$POLICY_NAME] at Priority: [$RULE_PRIORITY]..."

# 3. Execute gcloud update command
gcloud compute security-policies rules update "$RULE_PRIORITY" \
    --security-policy="$POLICY_NAME" \
    --src-ip-ranges="$ALL_IPS" \
    --project="$PROJECT_ID"

# 4. Check result
if [ $? -eq 0 ]; then
    echo "----------------------------------------------------------"
    echo "🎉 SUCCESS: Cloud Armor rule has been updated!"
    echo "🔒 Your Origin is now protected by Cloudflare IPs."
    echo "----------------------------------------------------------"
    exit 0
else
    echo "----------------------------------------------------------"
    echo "❌ FAILED: Update failed."
    echo "💡 Tip: Make sure you are logged in (gcloud auth login) and have 'Compute Security Admin' permissions."
    echo "----------------------------------------------------------"
    exit 1
fi

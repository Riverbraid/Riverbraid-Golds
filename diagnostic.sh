#!/bin/bash
# 🔍 Riverbraid Diagnostic: Token Scope & Permission Audit

echo "📡 INTERROGATING GITHUB API..."

if [ -z "$RB_TOKEN" ]; then
    echo "❌ ERROR: RB_TOKEN is empty in this session."
    exit 1
fi

# Call the API and capture the headers (where scopes are listed)
RESPONSE=$(curl -sI -H "Authorization: token $RB_TOKEN" https://api.github.com/user)

# Extract the X-OAuth-Scopes and X-Accepted-OAuth-Scopes
SCOPES=$(echo "$RESPONSE" | grep -i "X-OAuth-Scopes")
STATUS=$(echo "$RESPONSE" | grep "HTTP/")

echo "------------------------------------------------"
echo "📊 AUDIT RESULTS:"
echo "Status Code: $STATUS"
if [ -n "$SCOPES" ]; then
    echo "Current Scopes: $SCOPES"
else
    echo "❌ NO SCOPES FOUND. The token may be invalid, expired, or a Fine-Grained token with no global metadata."
fi

# Test write access to a specific petal repository
echo "------------------------------------------------"
echo "🧪 TESTING WRITE PERMISSION (Safety-Gold)..."
AUTH_TEST=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: token $RB_TOKEN" \
    -X GET https://api.github.com/repos/Riverbraid/Riverbraid-safety-gold)

if [ "$AUTH_TEST" == "200" ]; then
    echo "✅ Visibility: Repository is reachable."
else
    echo "❌ Visibility: HTTP $AUTH_TEST - Repository unreachable with this token."
fi
echo "------------------------------------------------"

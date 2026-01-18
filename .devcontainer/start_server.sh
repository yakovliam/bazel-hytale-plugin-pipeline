#!/bin/bash

# Configuration
CLIENT_ID="hytale-server"
SCOPES="openid offline auth:server"
AUTH_FILE="hytale_auth_data.json"
SERVER_JAR="HytaleServer.jar"
SERVER_ARGS="--assets Assets.zip --bind 0.0.0.0:5520"

URL_DEVICE_AUTH="https://oauth.accounts.hytale.com/oauth2/device/auth"
URL_TOKEN="https://oauth.accounts.hytale.com/oauth2/token"
URL_PROFILES="https://account-data.hytale.com/my-account/get-profiles"
URL_SESSION="https://sessions.hytale.com/game-session/new"

error_exit() {
    echo "Error: $1"
    exit 1
}

# Check for jq
if ! command -v jq &> /dev/null; then
    error_exit "jq is required but not installed. Please install jq."
fi

perform_device_auth() {
    echo "--- Initiating Device Authentication ---"
    
    # 1. Request Device Code
    RESPONSE=$(curl -s -X POST "$URL_DEVICE_AUTH" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "client_id=$CLIENT_ID" \
        -d "scope=$SCOPES")
    
    DEVICE_CODE=$(echo "$RESPONSE" | jq -r '.device_code')
    USER_CODE=$(echo "$RESPONSE" | jq -r '.user_code')
    VERIFICATION_URI=$(echo "$RESPONSE" | jq -r '.verification_uri_complete')
    INTERVAL=$(echo "$RESPONSE" | jq -r '.interval')
    
    if [ "$DEVICE_CODE" == "null" ]; then
        error_exit "Failed to get device code. Response: $RESPONSE"
    fi

    echo ""
    echo "=================================================================="
    echo " PLEASE AUTHENTICATE YOUR SERVER"
    echo " Visit the URL below in your browser to approve this server:"
    echo " URL:  $VERIFICATION_URI"
    echo " Code: $USER_CODE"
    echo "=================================================================="
    echo "Waiting for authorization..."

    while true; do
        sleep "${INTERVAL:-5}"
        
        TOKEN_RESPONSE=$(curl -s -X POST "$URL_TOKEN" \
            -H "Content-Type: application/x-www-form-urlencoded" \
            -d "client_id=$CLIENT_ID" \
            -d "grant_type=urn:ietf:params:oauth:grant-type:device_code" \
            -d "device_code=$DEVICE_CODE")
            
        ERROR=$(echo "$TOKEN_RESPONSE" | jq -r '.error')
        
        if [ "$ERROR" == "null" ]; then
            # Success!
            ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.access_token')
            REFRESH_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.refresh_token')
            # Save refresh token for future reuse
            echo "{\"refresh_token\": \"$REFRESH_TOKEN\"}" > "$AUTH_FILE"
            echo "Authentication successful!"
            break
        elif [ "$ERROR" == "authorization_pending" ]; then
            continue
        elif [ "$ERROR" == "slow_down" ]; then
            sleep 5
        elif [ "$ERROR" == "expired_token" ]; then
            error_exit "Authentication timed out. Please run the script again."
        else
            error_exit "Auth failed: $ERROR"
        fi
    done
}

refresh_oauth_token() {
    local REFRESH_TOKEN=$1
    echo "Attempting to refresh existing token..."
    
    TOKEN_RESPONSE=$(curl -s -X POST "$URL_TOKEN" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "client_id=$CLIENT_ID" \
        -d "grant_type=refresh_token" \
        -d "refresh_token=$REFRESH_TOKEN")

    ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.access_token')
    NEW_REFRESH_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.refresh_token')
    
    if [ "$ACCESS_TOKEN" != "null" ]; then
        # Update stored refresh token if a new one was sent
        if [ "$NEW_REFRESH_TOKEN" != "null" ]; then
             echo "{\"refresh_token\": \"$NEW_REFRESH_TOKEN\"}" > "$AUTH_FILE"
        fi
        return 0
    else
        echo "Token refresh failed. Re-authenticating..."
        return 1
    fi
}

if [ -f "$AUTH_FILE" ]; then
    STORED_REFRESH=$(jq -r '.refresh_token' "$AUTH_FILE")
    if [ "$STORED_REFRESH" != "null" ]; then
        refresh_oauth_token "$STORED_REFRESH"
        if [ $? -ne 0 ]; then
            perform_device_auth
        fi
    else
        perform_device_auth
    fi
else
    perform_device_auth
fi

echo "Fetching profile..."
PROFILE_RES=$(curl -s -X GET "$URL_PROFILES" -H "Authorization: Bearer $ACCESS_TOKEN")
# Select the first profile UUID available
PROFILE_UUID=$(echo "$PROFILE_RES" | jq -r '.profiles[0].uuid')

if [ "$PROFILE_UUID" == "null" ]; then
    error_exit "Could not retrieve profile UUID. Response: $PROFILE_RES"
fi
echo "Using Profile UUID: $PROFILE_UUID"

echo "Creating game session..."
SESSION_RES=$(curl -s -X POST "$URL_SESSION" \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"uuid\": \"$PROFILE_UUID\"}")

SESSION_TOKEN=$(echo "$SESSION_RES" | jq -r '.sessionToken')
IDENTITY_TOKEN=$(echo "$SESSION_RES" | jq -r '.identityToken')

if [ "$SESSION_TOKEN" == "null" ]; then
    error_exit "Failed to create game session. Response: $SESSION_RES"
fi

echo "--- Starting Hytale Server ---"
java -jar "$SERVER_JAR" \
    --session-token "$SESSION_TOKEN" \
    --identity-token "$IDENTITY_TOKEN" \
    $SERVER_ARGS
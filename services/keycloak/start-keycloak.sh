#!/bin/bash
set -e

# Import realm if it doesn't exist yet
if [ ! -f /opt/keycloak/data/.realm-imported ]; then
    echo "Importing realm..."
    /opt/keycloak/bin/kc.sh import --file /opt/keycloak/realms/master-realm.json
    touch /opt/keycloak/data/.realm-imported
    echo "Realm imported successfully"
fi

# Start Keycloak
exec /opt/keycloak/bin/kc.sh start-dev "$@"

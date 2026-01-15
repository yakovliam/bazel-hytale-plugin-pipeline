#!/bin/bash

#!/bin/bash
# Path for marker file
MARKER="/tmp/.deploy_finished"
LOCK="/tmp/.deploy.lock"

# If already finished, skip
if [ -f "$MARKER" ]; then
    echo "Deployment environment already set up."
    exit 0
fi

# Optional: prevent concurrent runs
if [ -f "$LOCK" ]; then
    echo "Deployment setup already in progress..."
    exit 1
fi
touch "$LOCK"

echo "Setting up deployment environment..."

# Create working server directory
mkdir /home/server

# Download the Hytale server for the development environment
wget -P /home/server https://artifacts.yakovliam.com/Assets.zip
wget -P /home/server https://artifacts.yakovliam.com/HytaleServer.jar

# Copy start_server.sh to working server directory
cp /workspace/.devcontainer/start_server.sh /home/server/start_server.sh
chmod +x /home/server/start_server.sh

echo "Deployment setup complete!"

# Create marker file
touch "$MARKER"

# Remove lock
rm "$LOCK"
#!/bin/bash
# Define a function to handle CTRL+C
cleanup() {
    exit 1
}

# Trap SIGINT (CTRL+C) and call the cleanup function
trap cleanup SIGINT

#!/bin/bash
MARKER="/tmp/.deploy_finished"

if [ -f "$MARKER" ]; then
    echo "Deployment env ready!"
else
    echo "Deployment env not ready yet!"
    exit
fi

###############################

# TODO: add select gui to pick pipeline
export PIPELINE=dev

# Build all targets
bazel build //... --//build_flags:pipeline=$PIPELINE

# Locate dist
EXECROOT=$(bazel info execution_root)
OUTPUT_REL=$(bazel cquery //plugin:dist --output=files | tail -n1)
DIST_FILE="$EXECROOT/$OUTPUT_REL"

if [ -n "$DIST_FILE" ]; then
    echo "Moving $DIST_FILE to server mods..."
    mkdir -p /home/server/mods
    cp "$DIST_FILE" /home/server/mods/
else
    echo "Error: Could not locate distribution file."
    exit 1
fi

echo "Deployed plugin to server."

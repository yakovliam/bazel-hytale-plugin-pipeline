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

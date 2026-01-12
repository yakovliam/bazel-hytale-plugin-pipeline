#!/bin/bash
# Define a function to handle CTRL+C
cleanup() {
    exit 1
}

# Trap SIGINT (CTRL+C) and call the cleanup function
trap cleanup SIGINT

# Load images
bazel run //k8s:load-all-images --//build_flags:pipeline=dev

# Apply within minikube
bazel run //k8s:apply-all --//build_flags:pipeline=dev


#!/bin/bash

# Build the MODULE.bazel file
python3 scripts/generate_module_bazel.py

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "MODULE.bazel generated successfully."
    # Now build the rest of the project
    bazel build //... --//build_flags:pipeline=dev
else
    echo "Failed to generate MODULE.bazel. Please check for errors."
fi

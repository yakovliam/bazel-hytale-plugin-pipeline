#!/bin/bash

# install buildifier
curl -L https://github.com/bazelbuild/buildtools/releases/download/v8.2.1/buildifier-linux-arm64 \
    -o /usr/local/bin/buildifier

# make buildifier executable
chmod +x /usr/local/bin/buildifier

# setup server
chmod +x ./setup_server.sh && \
 ./setup_server.sh
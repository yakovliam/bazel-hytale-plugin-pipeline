# Bazel Hytale Plugin Pipeline

Author: Jacob Cohen farakovengineering.com

A Bazel-based, containerized setup for building and deploying Java Hytale plugins. Supports offline assets, one-command deploy, and an authenticated local server.

## Structure
- plugin/: main module (src/, environment/)
- libs/: shared libraries (common-api/)
- build_defs/: macros and dependency imports
- build_flags/: Bazel flags (e.g., pipeline=dev|prod)
- .devcontainer/: automation (install-dependencies.sh, setup_server.sh, start_server.sh)
- .local-assets/: optional offline assets (Assets.zip, HytaleServer.jar)

## Dev Container Setup
- Open in VS Code and Reopen in Container.
- postCreate runs .devcontainer/install-dependencies.sh:
  - Installs buildifier
  - Runs setup_server.sh (idempotent) to prepare /home/server:
    - Uses /workspace/.local-assets if present
    - Otherwise downloads Assets.zip and HytaleServer.jar
    - Copies start_server.sh into /home/server
- Ports: 5520/udp exposed.
- Assets mount: .local-assets → /workspace/.local-assets

## Build and Deploy
- Dev build:
```bash
bazel build //... --//build_flags:pipeline=dev
```
- Prod build:
```bash
bazel build //... --//build_flags:pipeline=prod
```
- Deploy to server mods:
```bash
./deploy.sh
```

## Run the Server
```bash
cd /home/server
./start_server.sh
```
- Performs device auth if needed (stores refresh token), fetches profile/session, then runs:
  - java -jar HytaleServer.jar --assets Assets.zip --bind 0.0.0.0:5520

## Notes
- Offline: place Assets.zip and HytaleServer.jar in .local-assets before container creation.
- Adjust deploy.sh if your dist target or copy path differs.
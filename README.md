# Bazel Hytale Plugin Pipeline

A robust, Bazel-driven development environment for building and deploying Java-based plugins. This project leverages a
modular architecture with shared libraries, custom build flags for pipeline management, and a pre-configured Dev
Container for a seamless "spin-up and code" experience.

## 🏗 Project Structure

- `plugin/` — The main plugin module.
    - `src/` — Java source code and resources.
    - `environment/` — Pipeline-specific configurations.
- `libs/` — Shared libraries and common utilities.
    - `common-api/` — Shared API contracts and validation logic.
- `build_defs/` — Custom Bazel macros and shared build definitions (e.g., Hytale dependency imports).
- `build_flags/` — Configuration for custom Bazel flags (e.g., toggling between `dev` and `prod`).
- `scripts/` — Helper scripts for dynamic configuration generation (like `MODULE.bazel`).
- `.devcontainer/` — Full development environment definition including Java 25, Bazel, and automated setup.

## 🚀 Getting Started

### 1. Development Environment

The easiest way to get started is using **VS Code Remote Containers** or **IntelliJ Dev Containers**. The environment is
automatically configured with:

- Java 25
- Bazel
- A local server environment via `setup_server.sh`.

### 2. Manual Build

If building locally, ensure you have Bazel and Java 25 installed.

```bash
# 1. Generate dynamic Bazel configuration and build for dev
./build.sh

# 2. Or run manually
bazel build //... --//build_flags:pipeline=dev
```

## 🛠 Build & Deployment

### Environment Selection

We use a custom flag to handle different environments. This affects which configuration files are bundled.

```shell script
# Build for development (default)
bazel build //... --//build_flags:pipeline=dev

# Build for production
bazel build //... --//build_flags:pipeline=prod
```

### Deployment

To build the plugin and deploy it to the local server environment:

```shell script
./deploy.sh
```

This script builds the `:dist` target and copies the resulting shaded JAR to the `/home/server/mods` directory.

## 📦 Dependency Management

- **External Dependencies:** Managed via `MODULE.bazel` (Bzlmod) and `rules_jvm_external`.
- **Hytale Server:** Automatically fetched and provided as a dependency via `http_jar`.

## 📜 Conventions

- **Shaded Deps:** Libraries to be bundled with the plugin are defined in the `shade_deps` list in `plugin/BUILD.bazel`.
- **Provided Deps:** Server-side APIs (provided at runtime) are defined in `build_defs/hytale/import_bundles`.
- **Versioning:** Current project version is managed in the `BUILD.bazel` files.

# Bazel Service Pipeline

A multi-service, Bazel-driven backend stack with shared libraries and Kubernetes manifests. It includes gRPC/HTTP services, common API/service/web modules, and environment-specific configs for local, dev, and prod.

## Project Structure
- `libs/common-api` — Shared API contracts, validation, and config utilities.
- `libs/common-service` — Common service-layer configuration.
- `libs/common-web-service` — Web-related config (caching, security, JWT/user context, resolvers).
- `services/service-a` — Service A (gRPC client configs, Liquibase changelogs).
- `services/service-b` — Service B (gRPC service, proto definitions, Liquibase changelogs).
- `services/gateway` — Gateway service scaffold.
- `services/keycloak` — Keycloak-related assets and service scaffold.
- `k8s`, `services/*/configuration` — Kubernetes manifests and kustomize overlays (base/dev/prod).
- `bazel_config`, `build_defs`, `build_flags` — Bazel configuration and shared build definitions.
- `scripts`, `build.sh`, `deploy_dev.sh` — Helper scripts for build and dev deployment.

## Prerequisites
- Bazel
- Java 21 (configurable, typical for modern Spring/Java builds)
- Docker & Kubernetes tooling (kubectl, kustomize, or kubectl with kustomize support)

## Build & Test
```bash
# Fetch external deps
bazel fetch //...

# Build all targets
bazel build //...

# Run tests
bazel test //...
```
## Running Services (example)
```bash
# Service A
bazel run //services/service-a:ServiceAApplication

# Service B
bazel run //services/service-b:ServiceBApplication
```
## Database Migrations
Liquibase changelogs live under each service’s `resources/db/changelog`. Run via your preferred Liquibase runner or as part of service startup.

## Environment Selection (Build Flags)

This project uses a custom Bazel flag to toggle between environments during the build. This affects which configuration files, environment variables, or constants are bundled into the final artifacts.

By default, the pipeline is set to `dev`. You can explicitly set the environment using:

```bash
# Build for development (default)
bazel build //... --//build_flags:pipeline=dev

# Build for production
bazel build //... --//build_flags:pipeline=prod

# Workfllow to deploy to development
bazel run //k8s:load-all-images --//build_flags:pipeline=dev
bazel run //k8s:apply-all --//build_flags:pipeline=dev

# ... and so on
```

## Deployment
- **Dev:** `./deploy_dev.sh` (wraps Bazel/build steps and applies k8s manifests).
- **Kustomize overlays:** `services/*/configuration/{base,dev,prod}` and `k8s/` for cluster resources.

## Code Style & Conventions
- Organized as Bazel modules (`MODULE.bazel`, `BUILD.bazel` per component).
- Shared code resides in `libs/`.
- Proto sources under `services/{service name}/src/proto`.

## Getting Started
1) Install prerequisites.
2) `bazel fetch //...`
3) `bazel build //...`
4) Start services with `bazel run` or deploy to a k8s cluster using the provided overlays.

## Notes
- Update environment-specific values in `environment/` and kustomize overlays before deploying.
- Ensure Keycloak (or your IdP) is reachable if auth is enabled.
load("//build_defs/utils/environment:merge_envs.bzl", "merge_envs")

def k8s_service_manifest(name, service_name, library_labels):
    """
    Generates service manifests by merging environments from multiple libraries with service overrides.

    Args:
        name: Target name for the bundle.
        service_name: Name of the k8s service (used in YAML metadata).
        library_labels: List of base paths to libraries containing environment/dev and environment/prod.
    """

    # 1. Dynamically construct the library paths for each library
    # Collect selected env files from all libraries

    # Do the following:
    # {
    #   "library-key": [
    #     "base": [env-base.yaml],
    #     "[selected pipeline]": [env-[pipeline].yaml],
    #   ],
    # ... more libraries ...
    # }
    # --- Then ---
    # Merge the base with the selected pipeline env array for each library
    # --- Result ---
    # {
    #   "library-key": [env-[pipeline]-with-base.yaml],
    # ... more libraries ...
    # }
    # --- Then ---
    # Merge the services' base envs with the selected pipeline overlay for that service
    # (services/X/configuration/base/env-overrides.yaml + services/X/configuration/[selected pipeline]/env-overrides.yaml)
    # --- Result ---
    # [env-[pipeline]-with-base.yaml, env-overrides-[pipeline]-with-base.yaml]
    # Then, merge that list with every 'library' env array to create
    # ONE final list of envs to use.
    # [env-list-with-all-bases-and-[selected pipeline]-overlays.yaml]

    base_envs = [library_label + "/environment:env_base" for library_label in library_labels]
    base_overrides = "configuration/base/env-overrides.yaml"

    merge_envs(
        name = name + "_merge_all_list",
        # Library envs
        a_envs = select({
            "//build_flags:dev": base_envs + [l + "/environment:env_dev" for l in library_labels],
            "//build_flags:prod": base_envs + [l + "/environment:env_prod" for l in library_labels],
            "//conditions:default": base_envs,
        }),
        # Service envs
        b_envs = select({
            "//build_flags:dev": [base_overrides, "configuration/dev/env-overrides.yaml"],
            "//build_flags:prod": [base_overrides, "configuration/prod/env-overrides.yaml"],
            "//conditions:default": [base_overrides],
        }),
        out = "configuration/generated/env-merge-all-list.yaml",
    )

    # 4. Generate the Kustomize Patch
    native.genrule(
        name = name + "_patch_gen",
        srcs = ["configuration/generated/env-merge-all-list.yaml"],
        outs = ["configuration/generated/env-patch.yaml"],
        cmd = """
cat <<EOF > $(OUTS)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {svc}
spec:
  template:
    spec:
      containers:
      - name: {svc}
        env:
$$(sed 's/^/          /' $(SRCS))
EOF
""".format(svc = service_name),
    )

    # 4. Kustomize Build
    kustomization_select = select({
        "//build_flags:dev": ["configuration/dev/kustomization.yaml"],
        "//build_flags:prod": ["configuration/prod/kustomization.yaml"],
    })

    native.genrule(
        name = name + "_kustomized",
        srcs = kustomization_select + [
            "configuration/generated/env-patch.yaml",
        ] + native.glob(["configuration/base/*.yaml"]) + select({
            "//build_flags:dev": native.glob(["configuration/dev/*.yaml"], exclude = ["configuration/dev/kustomization.yaml"], allow_empty = True),
            "//build_flags:prod": native.glob(["configuration/prod/*.yaml"], exclude = ["configuration/prod/kustomization.yaml"], allow_empty = True),
            "//conditions:default": ([]),
        }),
        outs = ["configuration/generated/final-deployment.yaml"],
        cmd = """
   # Create a clean assembly area with proper structure
   BUILD_DIR="kustomize_workdir"
   mkdir -p $${BUILD_DIR}/base
   mkdir -p $${BUILD_DIR}/overlay

   # Copy files to the assembly area
   for f in $(SRCS); do
     if [[ $$f == *"configuration/base/"* ]]; then
       cp -f $$f $${BUILD_DIR}/base/
     elif [[ $$f == *"env-patch.yaml" ]]; then
       cp -f $$f $${BUILD_DIR}/overlay/env-patch.yaml
     elif [[ $$f == *"configuration/dev/kustomization.yaml" ]] || [[ $$f == *"configuration/prod/kustomization.yaml" ]]; then
       cp -f $$f $${BUILD_DIR}/overlay/kustomization.yaml
     fi
   done

   # Verify kustomization.yaml exists in the assembly
   if [ ! -f "$${BUILD_DIR}/overlay/kustomization.yaml" ]; then
     echo "Error: Failed to assemble kustomization.yaml in $${BUILD_DIR}/overlay"
     ls -la $${BUILD_DIR}/overlay/
     exit 1
   fi

   # Run Kustomize from the overlay directory
   kustomize build $${BUILD_DIR}/overlay > $(OUTS)
   """,
    )

    # ... existing code ...

    # 5. Export ONLY the result, not the raw patch
    native.filegroup(
        name = name,
        srcs = [
            "configuration/generated/final-deployment.yaml",
        ],
        visibility = ["//visibility:public"],
    )

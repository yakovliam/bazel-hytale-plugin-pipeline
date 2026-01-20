load("//build_defs/utils/environment:merge_envs.bzl", "merge_envs")

def environment_manifest(name, library_labels):
    """
    Generates environment manifests by merging environments from multiple libraries with service overrides.

    Args:
        name: Target name for the bundle.
        library_labels: List of base paths to libraries containing environment/dev and environment/prod.
    """
    base_envs = [library_label + "/environment:env_base" for library_label in library_labels]
    base_overrides = "//plugin/environment:env_base"

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
            "//build_flags:dev": [base_overrides, "//plugin/environment:env_dev"],
            "//build_flags:prod": [base_overrides, "//plugin/environment:env_prod"],
            "//conditions:default": [base_overrides],
        }),
        out = "generated/env-patch.yaml",
    )

    native.filegroup(
        name = name,
        srcs = [
            "generated/env-patch.yaml",
        ],
        visibility = ["//visibility:public"],
    )
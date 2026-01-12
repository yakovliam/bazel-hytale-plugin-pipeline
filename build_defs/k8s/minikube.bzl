def _minikube_load_image_impl(ctx):
    image_file = ctx.file.image_tarball

    script_content = """#!/bin/bash
set -e
echo "Loading {image_name} into minikube..."
minikube image load "{image_path}"
echo "✅ Image loaded!"
""".format(
        image_name = image_file.basename,
        image_path = image_file.path
    )

    script = ctx.actions.declare_file(ctx.label.name + ".sh")
    ctx.actions.write(
        output = script,
        content = script_content,
        is_executable = True,
    )

    return [DefaultInfo(
        executable = script,
        runfiles = ctx.runfiles(files = [image_file]),
    )]

minikube_load_image_rule = rule(
    implementation = _minikube_load_image_impl,
    attrs = {
        "image_tarball": attr.label(
            allow_single_file = [".tar"],
            mandatory = True,
        ),
    },
    executable = True,
)

def minikube_load_image(name, image_tarball, visibility = None):
    minikube_load_image_rule(
        name = name,
        image_tarball = image_tarball,
        visibility = visibility,
    )

def _minikube_load_all_impl(ctx):
    script_content = "#!/usr/bin/env bash\n"
    script_content += "set -euo pipefail\n"

    # Change to the workspace root directory first
    script_content += "cd \"$BUILD_WORKSPACE_DIRECTORY\"\n\n"

    # Load each image with its absolute path from workspace root
    for image in ctx.files.images:
        script_content += "echo \"Loading {short_path} into minikube...\"\n".format(short_path = image.short_path)
        script_content += "minikube image load \"{image_path}\"\n\n".format(image_path = image.path)

    script_content += "echo \"✅ All images loaded!\"\n"

    script = ctx.actions.declare_file(ctx.label.name + ".sh")

    ctx.actions.write(
        output = script,
        content = script_content,
        is_executable = True,
    )

    # The runfiles will ensure the image files are available
    return [DefaultInfo(
        executable = script,
        runfiles = ctx.runfiles(files = ctx.files.images),
    )]

minikube_load_all = rule(
    implementation = _minikube_load_all_impl,
    attrs = {
        "images": attr.label_list(
            allow_files = [".tar"],
            mandatory = True,
            doc = "List of OCI tarball targets to load",
        ),
    },
    executable = True,
)

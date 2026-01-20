def _manifest_gen_impl(ctx):
    out = ctx.actions.declare_file(ctx.attr.name + ".json")
    ctx.actions.write(out, ctx.attr.json_content)
    return [DefaultInfo(files = depset([out]))]

_manifest_gen = rule(
    implementation = _manifest_gen_impl,
    attrs = {"json_content": attr.string()},
)

def generate_manifest(name, config_dict):
    _manifest_gen(
        name = name,
        json_content = json.encode_indent(config_dict, indent = "  "),
        visibility = ["//visibility:public"],
    )

PipelineProvider = provider(fields = ['type'])

pipelines = ["dev", "prod"]

def _impl(ctx):
    raw_pipeline = ctx.build_setting_value
    if raw_pipeline not in pipelines:
        fail(str(ctx.label) + " build setting allowed to take values {"
             + ", ".join(pipelines) + "} but was set to unallowed value "
             + raw_pipeline)
    return PipelineProvider(type = raw_pipeline)

pipeline = rule(
    implementation = _impl,
    build_setting = config.string(flag = True),
)

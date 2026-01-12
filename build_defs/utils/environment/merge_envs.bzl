def _merge_envs_impl(ctx):
    output = ctx.outputs.out

    a_files = ctx.files.a_envs
    b_files = ctx.files.b_envs
    all_inputs = a_files + b_files

    ctx.actions.run_shell(
        inputs = all_inputs,
        outputs = [output],
        command = """
    # First arg is output, second is the count of group A
    output_path="$1"
    shift
    count_a="$1"
    shift

    # Concatenate inputs, guaranteeing a trailing newline between files
    tmpfile="$(mktemp)"
    > "$tmpfile"
    for f in "$@"; do
      [ -s "$f" ] || continue
      cat "$f" >> "$tmpfile"
      last_char=$(tail -c1 "$f" 2>/dev/null || true)
      if [ "$last_char" != $'\\n' ]; then
        printf '\\n' >> "$tmpfile"
      fi
    done

    cat "$tmpfile" | grep -v "^\\[\\]$" | grep -v "^$" > "$output_path"
    """,
        arguments = [output.path, str(len(a_files))] + [f.path for f in all_inputs],
    )

merge_envs = rule(
    implementation = _merge_envs_impl,
    attrs = {
        "a_envs": attr.label_list(allow_files = [".yaml"], mandatory = True),
        "b_envs": attr.label_list(allow_files = [".yaml"], mandatory = True),
        "out": attr.output(mandatory = True),
    },
    doc = "Merges multiple YAML lists of environment variables into a single list.",
)

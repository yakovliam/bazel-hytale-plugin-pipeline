#!/usr/bin/env python3
import json
import os

def resolve_variables(deps_list, variables):
    """Replace ${variable} placeholders with actual values"""
    resolved_deps = []
    for dep in deps_list:
        for var_name, var_value in variables.items():
            placeholder = "${" + var_name + "}"
            dep = dep.replace(placeholder, var_value)
        resolved_deps.append(dep)
    return resolved_deps

def generate_maven_section():
    """Generate the maven.install section from maven_deps.json"""
    with open('maven_deps.json', 'r') as f:
        deps_data = json.load(f)

    # Extract variables and dependencies
    variables = deps_data.get("variables", {})
    dependencies = deps_data.get("dependencies", {})

    all_deps = []
    for category, deps_list in dependencies.items():
        resolved_deps = resolve_variables(deps_list, variables)
        all_deps.extend(resolved_deps)

    # Remove duplicates and sort for consistency
    all_deps = sorted(set(all_deps))

    section = []
    # section.append('maven = use_extension("@rules_jvm_external//:extensions.bzl", "maven")')
    section.append('maven.install(')
    section.append('    name = "maven",')
    section.append('    artifacts = [')

    for dep in all_deps:
        section.append(f'        "{dep}",')

    section.append('    ],')
    section.append('    repositories = [')
    section.append('        "https://repo1.maven.org/maven2",')
    section.append('        "https://maven.hytale.com/pre-release",')
    section.append('    ],')
    section.append('    generate_compat_repositories = True,')
    section.append(')')

    return '\n'.join(section)

def generate_module_bazel():
    """Generate the complete MODULE.bazel file from template"""

    # Read the template
    with open('MODULE.template.bazel', 'r') as f:
        template = f.read()

    # Generate the maven deps section
    maven_section = generate_maven_section()

    # Replace the placeholder
    new_content = template.replace('### MAVEN_DEPS_SECTION ###', maven_section)

    # Write the actual MODULE.bazel
    with open('MODULE.bazel', 'w') as f:
        f.write(new_content)

    print(f"Generated MODULE.bazel with {len(maven_section.splitlines())} lines of maven configuration")
    print("Don't edit MODULE.bazel directly; use MODULE.template.bazel and maven_deps.json")

if __name__ == '__main__':
    generate_module_bazel()

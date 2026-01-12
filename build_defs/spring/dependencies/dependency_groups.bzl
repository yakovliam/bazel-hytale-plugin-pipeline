GSON_DEPS = [
    "@maven//:com_google_code_gson_gson",
]

JAVA_BASE_DEPS = [
    "@maven//:org_slf4j_slf4j_api",
    "@maven//:ch_qos_logback_logback_classic",
]

MICROSERVICE_API_DEPS = [
    "@maven//:org_springframework_boot_spring_boot_starter_security",
    "@maven//:org_springframework_boot_spring_boot_starter_validation",
    "@maven//:jakarta_annotation_jakarta_annotation_api",
    "@maven//:org_springframework_security_spring_security_core",
    "@maven//:org_springframework_spring_webmvc",
    "@maven//:org_springframework_spring_web",
    "@maven//:org_springframework_spring_context",
    "@maven//:org_springframework_spring_core",
    "@maven//:org_springframework_spring_context_support",
    "@maven//:org_springframework_spring_beans",
    "@maven//:org_springframework_security_spring_security_config",
    "@maven//:org_springframework_security_spring_security_web",
    "@maven//:org_jetbrains_annotations",
] + GSON_DEPS + JAVA_BASE_DEPS

MICROSERVICE_DEPS = [
    "@maven//:org_springframework_boot_spring_boot",
    "@maven//:org_springframework_boot_spring_boot_starter_web",
    "@maven//:org_springframework_boot_spring_boot_starter_cache",
    "@maven//:com_github_ben_manes_caffeine_caffeine",
    "@maven//:com_squareup_okhttp3_okhttp",
    "@maven//:org_mapstruct_mapstruct",
    "@maven//:com_squareup_okio_okio_jvm",
] + MICROSERVICE_API_DEPS

MICROSERVICE_WEB_DEPS = [
    "@maven//:org_springframework_boot_spring_boot_starter_oauth2_client",
    "@maven//:org_springframework_boot_spring_boot_starter_oauth2_resource_server",
    "@maven//:org_springframework_security_spring_security_oauth2_jose",
    "@maven//:com_auth0_java_jwt",
] + MICROSERVICE_DEPS

GRPC_DEPS = [
    "@maven//:io_grpc_grpc_services",
    "@maven//:io_grpc_grpc_protobuf",
    "@maven//:com_google_protobuf_protobuf_java",
    "@maven//:io_grpc_grpc_stub",
    "@maven//:org_springframework_grpc_spring_grpc_core",
]

GRPC_STARTER_DEPS = [
    "@maven//:org_springframework_grpc_spring_grpc_server_spring_boot_starter",
] + GRPC_DEPS

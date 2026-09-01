$ mkdir ~/dbx_build_tools_guide
$ cd ~/dbx_build_tools_guide

$ cat > .bazelrc
build --experimental_strict_action_env
build --platforms @dbx_build_tools//build_tools/cc:linux-x64-drte-off
build --host_platform @dbx_build_tools//build_tools/cc:linux-x64-drte-off
build --sandbox_fake_username
build --modify_execution_info=TestRunner=+block-network

# Work around https://github.com/bazelbuild/bazel/issues/6293 by setting a
# dummy lcov.
coverage --test_env=LCOV_MERGER=/bin/true

$ cat > WORKSPACE
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")


# Real use cases should pin a commit and set the sha256.
http_archive(
    name = "dbx_build_tools",
    urls = ["https://github.com/dropbox/dbx_build_tools/archive/master.tar.gz"],
    strip_prefix = "dbx_build_tools-master",
)

load('@dbx_build_tools//build_tools/bazel:external_workspace.bzl', 'drte_deps')

drte_deps()

register_toolchains(
    "@dbx_build_tools//thirdparty/cpython:drte-off-39-toolchain",
)

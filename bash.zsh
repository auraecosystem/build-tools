$ bazel build @dbx_build_tools//build_tools:bzl
$ sudo cp -rL bazel-bin/external/dbx_build_tools/build_tools/bzl{,.runfiles} /usr/bin/
$ bzl itest-start //python/website:website_service
$ curl http://localhost:5432
<html><strong>Hello</strong></html>
$ bzl itest-stop //python/website:website_service

$ mkdir -p python/website
$ cat > python/website/hello.py
import random


def say_hello():
    return 'Hello'

$ cat > python/website/main.py
import sys

from wsgiref.simple_server import make_server

from python.website.hello import say_hello


def hello_app(environ, start_response):
    start_response('200 OK', [('Content-type', 'text/html')])

    return [
        '<html><strong>',
        say_hello(),
        '</strong></html>',
    ]


def main(port):
    server = make_server('localhost', port, hello_app)
    server.serve_forever()


if __name__ == '__main__':
    main(int(sys.argv[1]))

$ cat > python/website/BUILD.in
load('@dbx_build_tools//build_tools/services:svc.bzl', 'dbx_service_daemon')


dbx_py_library(
    name = "hello",
    srcs = ["hello.py"],
)

dbx_py_binary(
    name = "website",
    main = 'main.py',
)

dbx_service_daemon(
    name = "website_service",
    owner = "web_site_team",
    exe = ":website",
    args = ['5432'],
    http_health_check = 'http://localhost:5432',
)

$ bzl gen //python/website/...

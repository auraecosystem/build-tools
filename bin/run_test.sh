$ cat > python/website/unit_test.py
from python.website.hello import say_hello


def test_say_hello():
    assert say_hello() == 'Hello'

$ cat > python/website/itest.py
try:
    from urllib2 import urlopen
except ImportError:
    from urllib.request import urlopen


def test_hello():
    assert b'Hello' in urlopen('http://localhost:5432').read()

$ cat >> python/website/BUILD.in

dbx_py_pytest_test(
    name ='unit_test',
    srcs = ['unit_test.py'],
)

dbx_py_pytest_test(
    name ='itest',
    srcs = ['itest.py'],
    services = [":website_service"],
)

$ bzl gen //python/website/...
$ bazel test //python/website/...
INFO: Elapsed time: 46.494s, Critical Path: 40.22s
INFO: 1618 processes: 1578 linux-sandbox, 40 local.
INFO: Build completed successfully, 1825 total actions
//python/website:itest                                                   PASSED in 1.3s
//python/website:unit_test                                               PASSED in 1.1s
//python/website:website_service_service_test                            PASSED in 0.5s

INFO: Build completed successfully, 1825 total actions

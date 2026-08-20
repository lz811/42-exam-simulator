#!/bin/bash
source ../../../main/colors.sh 2>/dev/null

expected_file="package_dependency_resolver.py"
rendu_dir="../../../../rendu/package_dependency_resolver"

if [ ! -f "$rendu_dir/$expected_file" ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: Missing file $expected_file$(tput sgr 0)"
    exit 1
fi

echo "$(tput setaf 6)Checking package_dependency_resolver implementation...$(tput sgr 0)"

python3 - "$rendu_dir" <<'PYEOF'
import importlib.util
import random
import string
import sys


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


rendu_dir = sys.argv[1]

try:
    ref = load("ref_package_dependency_resolver", "package_dependency_resolver.py")
except Exception as e:
    print("FAIL: internal reference error -> " + repr(e))
    sys.exit(1)

try:
    sub = load("sub_package_dependency_resolver", rendu_dir + "/package_dependency_resolver.py")
except Exception as e:
    print("FAIL: could not import package_dependency_resolver.py -> " + repr(e))
    sys.exit(1)

if not hasattr(sub, "package_dependency_resolver"):
    print("FAIL: function package_dependency_resolver not found in package_dependency_resolver.py")
    sys.exit(1)

f_ref = ref.package_dependency_resolver
f_sub = sub.package_dependency_resolver

tests = [
    {"a": [], "b": ["a"], "c": ["a", "b"]},
    {"a": ["b"], "b": ["a"]},
    {"a": ["x"]},
    {},
    {"a": [], "b": [], "c": ["a", "b"], "d": ["c"]},
]

random.seed(21)
names = list(string.ascii_lowercase[:8])
for _ in range(15):
    n = random.randint(0, 6)
    chosen = names[:n]
    packages = {}
    for name in chosen:
        possible = [c for c in chosen if c != name]
        k = random.randint(0, len(possible))
        packages[name] = random.sample(possible, k)
    tests.append(packages)

failed = False
for packages in tests:
    try:
        expected = f_ref({k: v[:] for k, v in packages.items()})
    except Exception:
        continue
    try:
        result = f_sub({k: v[:] for k, v in packages.items()})
    except Exception as e:
        print("FAIL: package_dependency_resolver(" + repr(packages) + ") raised " + repr(e))
        failed = True
        continue
    if result != expected:
        print("FAIL: package_dependency_resolver(" + repr(packages) + ") = " + repr(result) + ", expected " + repr(expected))
        failed = True

sys.exit(1 if failed else 0)
PYEOF

if [ $? -ne 0 ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: one or more test cases failed$(tput sgr 0)"
    exit 1
fi

echo "$(tput setaf 2)$(tput bold)PASSED 🎉$(tput sgr 0)"
exit 0

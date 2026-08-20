#!/bin/bash
source ../../../main/colors.sh 2>/dev/null

expected_file="palindrome_partitioner.py"
rendu_dir="../../../../rendu/palindrome_partitioner"

if [ ! -f "$rendu_dir/$expected_file" ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: Missing file $expected_file$(tput sgr 0)"
    exit 1
fi

echo "$(tput setaf 6)Checking palindrome_partitioner implementation...$(tput sgr 0)"

python3 - "$rendu_dir" <<'PYEOF'
import importlib.util
import random
import sys


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


rendu_dir = sys.argv[1]

try:
    ref = load("ref_palindrome_partitioner", "palindrome_partitioner.py")
except Exception as e:
    print("FAIL: internal reference error -> " + repr(e))
    sys.exit(1)

try:
    sub = load("sub_palindrome_partitioner", rendu_dir + "/palindrome_partitioner.py")
except Exception as e:
    print("FAIL: could not import palindrome_partitioner.py -> " + repr(e))
    sys.exit(1)

if not hasattr(sub, "palindrome_partitioner"):
    print("FAIL: function palindrome_partitioner not found in palindrome_partitioner.py")
    sys.exit(1)

f_ref = ref.palindrome_partitioner
f_sub = sub.palindrome_partitioner

tests = ["", "a", "aab", "racecar", "ab", "aabb", "abcba", "noonracecar"]

random.seed(5)
alphabet = "ab"
for length in range(0, 11):
    for _ in range(3):
        tests.append("".join(random.choice(alphabet) for _ in range(length)))

alphabet2 = "abc"
for _ in range(10):
    length = random.randint(0, 10)
    tests.append("".join(random.choice(alphabet2) for _ in range(length)))

failed = False
for s in tests:
    try:
        expected = f_ref(s)
    except Exception:
        continue
    try:
        result = f_sub(s)
    except Exception as e:
        print("FAIL: palindrome_partitioner(" + repr(s) + ") raised " + repr(e))
        failed = True
        continue
    if result != expected:
        print("FAIL: palindrome_partitioner(" + repr(s) + ") = " + repr(result) + ", expected " + repr(expected))
        failed = True

sys.exit(1 if failed else 0)
PYEOF

if [ $? -ne 0 ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: one or more test cases failed$(tput sgr 0)"
    exit 1
fi

echo "$(tput setaf 2)$(tput bold)PASSED 🎉$(tput sgr 0)"
exit 0

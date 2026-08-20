#!/bin/bash
source ../../../main/colors.sh 2>/dev/null

expected_file="constellation_mapper.py"
rendu_dir="../../../../rendu/constellation_mapper"

if [ ! -f "$rendu_dir/$expected_file" ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: Missing file $expected_file$(tput sgr 0)"
    exit 1
fi

echo "$(tput setaf 6)Checking constellation_mapper implementation...$(tput sgr 0)"

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
    ref = load("ref_constellation_mapper", "constellation_mapper.py")
except Exception as e:
    print("FAIL: internal reference error -> " + repr(e))
    sys.exit(1)

try:
    sub = load("sub_constellation_mapper", rendu_dir + "/constellation_mapper.py")
except Exception as e:
    print("FAIL: could not import constellation_mapper.py -> " + repr(e))
    sys.exit(1)

if not hasattr(sub, "constellation_mapper"):
    print("FAIL: function constellation_mapper not found in constellation_mapper.py")
    sys.exit(1)

f_ref = ref.constellation_mapper
f_sub = sub.constellation_mapper

tests = [
    ([(0, 0), (1, 1)], 3),
    ([], 2),
    ([(0, 0), (0, 1), (0, 2)], 3),
    ([(5, 5)], 3),
    ([(0, 0)], 1),
]

random.seed(7)
for _ in range(15):
    size = random.randint(1, 6)
    count = random.randint(0, size * size)
    stars = [(random.randint(0, size - 1), random.randint(0, size - 1)) for _ in range(count)]
    tests.append((stars, size))

failed = False
for stars, size in tests:
    try:
        expected = f_ref(list(stars), size)
    except Exception:
        continue
    try:
        result = f_sub(list(stars), size)
    except Exception as e:
        print("FAIL: constellation_mapper(" + repr(stars) + ", " + repr(size) + ") raised " + repr(e))
        failed = True
        continue
    if result != expected:
        print("FAIL: constellation_mapper(" + repr(stars) + ", " + repr(size) + ") = " + repr(result) + ", expected " + repr(expected))
        failed = True

sys.exit(1 if failed else 0)
PYEOF

if [ $? -ne 0 ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: one or more test cases failed$(tput sgr 0)"
    exit 1
fi

echo "$(tput setaf 2)$(tput bold)PASSED 🎉$(tput sgr 0)"
exit 0

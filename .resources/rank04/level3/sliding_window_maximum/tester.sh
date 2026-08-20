#!/bin/bash
source ../../../main/colors.sh 2>/dev/null

expected_file="sliding_window_maximum.py"
rendu_dir="../../../../rendu/sliding_window_maximum"

if [ ! -f "$rendu_dir/$expected_file" ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: Missing file $expected_file$(tput sgr 0)"
    exit 1
fi

echo "$(tput setaf 6)Checking sliding_window_maximum implementation...$(tput sgr 0)"

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
    ref = load("ref_sliding_window_maximum", "sliding_window_maximum.py")
except Exception as e:
    print("FAIL: internal reference error -> " + repr(e))
    sys.exit(1)

try:
    sub = load("sub_sliding_window_maximum", rendu_dir + "/sliding_window_maximum.py")
except Exception as e:
    print("FAIL: could not import sliding_window_maximum.py -> " + repr(e))
    sys.exit(1)

if not hasattr(sub, "sliding_window_maximum"):
    print("FAIL: function sliding_window_maximum not found in sliding_window_maximum.py")
    sys.exit(1)

f_ref = ref.sliding_window_maximum
f_sub = sub.sliding_window_maximum

tests = [
    ([1, 3, -1, -3, 5, 3, 6, 7], 3),
    ([], 1),
    ([4, 2], 5),
    ([9], 1),
    ([1, 1, 1, 1], 2),
    ([5, 4, 3, 2, 1], 0),
]

random.seed(9)
for _ in range(15):
    n = random.randint(0, 10)
    nums = [random.randint(-10, 10) for _ in range(n)]
    k = random.randint(0, n + 2)
    tests.append((nums, k))

failed = False
for nums, k in tests:
    try:
        expected = list(f_ref(nums[:], k))
    except Exception:
        continue
    try:
        result = list(f_sub(nums[:], k))
    except Exception as e:
        print("FAIL: sliding_window_maximum(" + repr(nums) + ", " + repr(k) + ") raised " + repr(e))
        failed = True
        continue
    if result != expected:
        print("FAIL: sliding_window_maximum(" + repr(nums) + ", " + repr(k) + ") = " + repr(result) + ", expected " + repr(expected))
        failed = True

sys.exit(1 if failed else 0)
PYEOF

if [ $? -ne 0 ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: one or more test cases failed$(tput sgr 0)"
    exit 1
fi

echo "$(tput setaf 2)$(tput bold)PASSED 🎉$(tput sgr 0)"
exit 0

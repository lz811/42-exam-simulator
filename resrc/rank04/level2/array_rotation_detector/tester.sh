#!/bin/bash
source ../../../main/colors.sh 2>/dev/null

expected_file="array_rotation_detector.py"
rendu_dir="../../../../rendu/array_rotation_detector"

if [ ! -f "$rendu_dir/$expected_file" ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: Missing file $expected_file$(tput sgr 0)"
    exit 1
fi

echo "$(tput setaf 6)Checking array_rotation_detector implementation...$(tput sgr 0)"

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
    ref = load("ref_array_rotation_detector", "array_rotation_detector.py")
except Exception as e:
    print("FAIL: internal reference error -> " + repr(e))
    sys.exit(1)

try:
    sub = load("sub_array_rotation_detector", rendu_dir + "/array_rotation_detector.py")
except Exception as e:
    print("FAIL: could not import array_rotation_detector.py -> " + repr(e))
    sys.exit(1)

if not hasattr(sub, "array_rotation_detector"):
    print("FAIL: function array_rotation_detector not found in array_rotation_detector.py")
    sys.exit(1)

f_ref = ref.array_rotation_detector
f_sub = sub.array_rotation_detector

tests = [
    ([1, 2, 3, 4, 5], [3, 4, 5, 1, 2]),
    ([1, 2, 3], [3, 2, 1]),
    ([1, 1, 2], [1, 2, 1]),
    ([], []),
    ([1, 2, 3], [1, 2]),
    ([1], [1]),
    ([1, 2], [2, 1]),
]

random.seed(42)
for _ in range(20):
    n = random.randint(0, 8)
    arr1 = [random.randint(-5, 5) for _ in range(n)]
    if n and random.random() < 0.6:
        k = random.randint(0, n - 1)
        arr2 = arr1[k:] + arr1[:k]
    else:
        arr2 = arr1[:]
        random.shuffle(arr2)
    tests.append((arr1, arr2))

failed = False
for arr1, arr2 in tests:
    args = ([arr1[:], arr2[:]])
    try:
        expected = f_ref(arr1[:], arr2[:])
    except Exception as e:
        continue
    try:
        result = f_sub(arr1[:], arr2[:])
    except Exception as e:
        print("FAIL: array_rotation_detector(" + repr(arr1) + ", " + repr(arr2) + ") raised " + repr(e))
        failed = True
        continue
    if result != expected:
        print("FAIL: array_rotation_detector(" + repr(arr1) + ", " + repr(arr2) + ") = " + repr(result) + ", expected " + repr(expected))
        failed = True

sys.exit(1 if failed else 0)
PYEOF

if [ $? -ne 0 ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: one or more test cases failed$(tput sgr 0)"
    exit 1
fi

echo "$(tput setaf 2)$(tput bold)PASSED 🎉$(tput sgr 0)"
exit 0

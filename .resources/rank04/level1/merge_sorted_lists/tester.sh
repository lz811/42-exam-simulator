#!/bin/bash
source ../../../main/colors.sh 2>/dev/null

expected_file="merge_sorted_lists.py"
rendu_dir="../../../../rendu/merge_sorted_lists"

if [ ! -f "$rendu_dir/$expected_file" ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: Missing file $expected_file$(tput sgr 0)"
    exit 1
fi

echo "$(tput setaf 6)Checking merge_sorted_lists implementation...$(tput sgr 0)"

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
    ref = load("ref_merge_sorted_lists", "merge_sorted_lists.py")
except Exception as e:
    print("FAIL: internal reference error -> " + repr(e))
    sys.exit(1)

try:
    sub = load("sub_merge_sorted_lists", rendu_dir + "/merge_sorted_lists.py")
except Exception as e:
    print("FAIL: could not import merge_sorted_lists.py -> " + repr(e))
    sys.exit(1)

if not hasattr(sub, "merge_sorted_lists"):
    print("FAIL: function merge_sorted_lists not found in merge_sorted_lists.py")
    sys.exit(1)

f_ref = ref.merge_sorted_lists
f_sub = sub.merge_sorted_lists

tests = [
    [[1, 3, 5], [2, 4, 6]],
    [[5, 1], [3], []],
    [],
    [[]],
]

random.seed(3)
for _ in range(15):
    n_lists = random.randint(0, 4)
    lists = []
    for _ in range(n_lists):
        length = random.randint(0, 6)
        lists.append([random.randint(-10, 10) for _ in range(length)])
    tests.append(lists)

failed = False
for lists in tests:
    try:
        expected = f_ref([lst[:] for lst in lists])
    except Exception:
        continue
    try:
        result = f_sub([lst[:] for lst in lists])
    except Exception as e:
        print("FAIL: merge_sorted_lists(" + repr(lists) + ") raised " + repr(e))
        failed = True
        continue
    if result != expected:
        print("FAIL: merge_sorted_lists(" + repr(lists) + ") = " + repr(result) + ", expected " + repr(expected))
        failed = True

sys.exit(1 if failed else 0)
PYEOF

if [ $? -ne 0 ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: one or more test cases failed$(tput sgr 0)"
    exit 1
fi

echo "$(tput setaf 2)$(tput bold)PASSED 🎉$(tput sgr 0)"
exit 0

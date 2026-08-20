#!/bin/bash
source ../../../main/colors.sh 2>/dev/null

expected_file="list_intersection_finder.py"
rendu_dir="../../../../rendu/list_intersection_finder"

if [ ! -f "$rendu_dir/$expected_file" ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: Missing file $expected_file$(tput sgr 0)"
    exit 1
fi

echo "$(tput setaf 6)Checking list_intersection_finder implementation...$(tput sgr 0)"

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
    ref = load("ref_list_intersection_finder", "list_intersection_finder.py")
except Exception as e:
    print("FAIL: internal reference error -> " + repr(e))
    sys.exit(1)

try:
    sub = load("sub_list_intersection_finder", rendu_dir + "/list_intersection_finder.py")
except Exception as e:
    print("FAIL: could not import list_intersection_finder.py -> " + repr(e))
    sys.exit(1)

if not hasattr(sub, "list_intersection_finder"):
    print("FAIL: function list_intersection_finder not found in list_intersection_finder.py")
    sys.exit(1)

f_ref = ref.list_intersection_finder
f_sub = sub.list_intersection_finder

tests = [
    [[1, 2, 3], [2, 3, 4], [2, 5]],
    [[1, 2], []],
    [],
    [[3, 1, 2]],
    [[1, 1, 2], [1, 2, 2], [1, 2, 3]],
]

random.seed(11)
for _ in range(15):
    n_lists = random.randint(0, 4)
    lists = []
    for _ in range(n_lists):
        length = random.randint(0, 6)
        lists.append([random.randint(0, 6) for _ in range(length)])
    tests.append(lists)

failed = False
for lists in tests:
    args = [lst[:] for lst in lists]
    try:
        expected = f_ref([lst[:] for lst in lists])
    except Exception:
        continue
    try:
        result = f_sub([lst[:] for lst in lists])
    except Exception as e:
        print("FAIL: list_intersection_finder(" + repr(lists) + ") raised " + repr(e))
        failed = True
        continue
    if result != expected:
        print("FAIL: list_intersection_finder(" + repr(lists) + ") = " + repr(result) + ", expected " + repr(expected))
        failed = True

sys.exit(1 if failed else 0)
PYEOF

if [ $? -ne 0 ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: one or more test cases failed$(tput sgr 0)"
    exit 1
fi

echo "$(tput setaf 2)$(tput bold)PASSED 🎉$(tput sgr 0)"
exit 0

#!/bin/bash
source ../../../main/colors.sh

expected_file="twist_sequence.py"
rendu_dir="../../../../rendu/twist_sequence"

if [ ! -f "$rendu_dir/$expected_file" ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: Missing file $expected_file$(tput sgr 0)"
    exit 1
fi

echo "${BLUE}Checking twist_sequence implementation...${RESET}"

python3 - "$rendu_dir" <<'PYEOF'
import importlib.util
import sys

rendu_dir = sys.argv[1] if len(sys.argv) > 1 else "."
spec = importlib.util.spec_from_file_location("twist_sequence", rendu_dir + "/twist_sequence.py")
module = importlib.util.module_from_spec(spec)
try:
    spec.loader.exec_module(module)
except Exception as e:
    print("FAIL: could not import twist_sequence.py -> " + str(e))
    sys.exit(1)

if not hasattr(module, "py_twist_sequence"):
    print("FAIL: function py_twist_sequence not found in twist_sequence.py")
    sys.exit(1)

f = getattr(module, "py_twist_sequence")

tests = [
    ([1, 2, 3, 4, 5], 2, [4, 5, 1, 2, 3]),
    ([1, 2, 3], 1, [3, 1, 2]),
    ([1, 2, 3, 4], 0, [1, 2, 3, 4]),
    ([1, 2, 3], 5, [2, 3, 1]),
    ([], 3, []),
]

failed = False
for case in tests:
    *args, expected = case
    try:
        result = f(*args)
    except Exception as e:
        print("FAIL: py_twist_sequence(" + repr(args) + ") raised " + repr(e))
        failed = True
        continue
    if result != expected:
        print("FAIL: py_twist_sequence(" + repr(args) + ") = " + repr(result) + ", expected " + repr(expected))
        failed = True

if failed:
    sys.exit(1)
sys.exit(0)
PYEOF

if [ $? -ne 0 ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: one or more test cases failed$(tput sgr 0)"
    exit 1
fi

echo "$(tput setaf 2)$(tput bold)PASSED 🎉$(tput sgr 0)"
exit 0

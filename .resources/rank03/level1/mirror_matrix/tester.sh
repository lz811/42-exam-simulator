#!/bin/bash
source ../../../main/colors.sh

expected_file="mirror_matrix.py"
rendu_dir="../../../../rendu/mirror_matrix"

if [ ! -f "$rendu_dir/$expected_file" ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: Missing file $expected_file$(tput sgr 0)"
    exit 1
fi

echo "${BLUE}Checking mirror_matrix implementation...${RESET}"

python3 - "$rendu_dir" <<'PYEOF'
import importlib.util
import sys

rendu_dir = sys.argv[1] if len(sys.argv) > 1 else "."
spec = importlib.util.spec_from_file_location("mirror_matrix", rendu_dir + "/mirror_matrix.py")
module = importlib.util.module_from_spec(spec)
try:
    spec.loader.exec_module(module)
except Exception as e:
    print("FAIL: could not import mirror_matrix.py -> " + str(e))
    sys.exit(1)

if not hasattr(module, "py_mirror_matrix"):
    print("FAIL: function py_mirror_matrix not found in mirror_matrix.py")
    sys.exit(1)

f = getattr(module, "py_mirror_matrix")

tests = [
    ([[1, 2, 3], [4, 5, 6]], [[3, 2, 1], [6, 5, 4]]),
    ([[1, 2], [3, 4], [5, 6]], [[2, 1], [4, 3], [6, 5]]),
    ([[7]], [[7]]),
    ([[1, 2, 3, 4]], [[4, 3, 2, 1]]),
]

failed = False
for case in tests:
    *args, expected = case
    try:
        result = f(*args)
    except Exception as e:
        print("FAIL: py_mirror_matrix(" + repr(args) + ") raised " + repr(e))
        failed = True
        continue
    if result != expected:
        print("FAIL: py_mirror_matrix(" + repr(args) + ") = " + repr(result) + ", expected " + repr(expected))
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

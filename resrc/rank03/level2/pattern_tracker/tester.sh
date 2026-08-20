#!/bin/bash
source ../../../main/colors.sh

expected_file="pattern_tracker.py"
rendu_dir="../../../../rendu/pattern_tracker"

if [ ! -f "$rendu_dir/$expected_file" ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: Missing file $expected_file$(tput sgr 0)"
    exit 1
fi

echo "${BLUE}Checking pattern_tracker implementation...${RESET}"

python3 - "$rendu_dir" <<'PYEOF'
import importlib.util
import sys

rendu_dir = sys.argv[1] if len(sys.argv) > 1 else "."
spec = importlib.util.spec_from_file_location("pattern_tracker", rendu_dir + "/pattern_tracker.py")
module = importlib.util.module_from_spec(spec)
try:
    spec.loader.exec_module(module)
except Exception as e:
    print("FAIL: could not import pattern_tracker.py -> " + str(e))
    sys.exit(1)

if not hasattr(module, "py_pattern_tracker"):
    print("FAIL: function py_pattern_tracker not found in pattern_tracker.py")
    sys.exit(1)

f = getattr(module, "py_pattern_tracker")

tests = [
    ("123", 2),
    ("12a34", 2),
    ("987654321", 0),
    ("01234567", 7),
    ("abc", 0),
    ("1a2b3c4", 0),
    ("112233", 2),
]

failed = False
for case in tests:
    *args, expected = case
    try:
        result = f(*args)
    except Exception as e:
        print("FAIL: py_pattern_tracker(" + repr(args) + ") raised " + repr(e))
        failed = True
        continue
    if result != expected:
        print("FAIL: py_pattern_tracker(" + repr(args) + ") = " + repr(result) + ", expected " + repr(expected))
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

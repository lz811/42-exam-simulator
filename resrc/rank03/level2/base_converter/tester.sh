#!/bin/bash
source ../../../main/colors.sh

expected_file="base_converter.py"
rendu_dir="../../../../rendu/base_converter"

if [ ! -f "$rendu_dir/$expected_file" ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: Missing file $expected_file$(tput sgr 0)"
    exit 1
fi

echo "${BLUE}Checking base_converter implementation...${RESET}"

python3 - "$rendu_dir" <<'PYEOF'
import importlib.util
import sys

rendu_dir = sys.argv[1] if len(sys.argv) > 1 else "."
spec = importlib.util.spec_from_file_location("base_converter", rendu_dir + "/base_converter.py")
module = importlib.util.module_from_spec(spec)
try:
    spec.loader.exec_module(module)
except Exception as e:
    print("FAIL: could not import base_converter.py -> " + str(e))
    sys.exit(1)

if not hasattr(module, "py_number_base_converter"):
    print("FAIL: function py_number_base_converter not found in base_converter.py")
    sys.exit(1)

f = getattr(module, "py_number_base_converter")

tests = [
    ("1010", 2, 10, "10"),
    ("FF", 16, 10, "255"),
    ("255", 10, 16, "FF"),
    ("123", 10, 2, "1111011"),
    ("Z", 36, 10, "35"),
    ("35", 10, 36, "Z"),
    ("123", 1, 10, "ERROR"),
    ("G", 16, 10, "ERROR"),
]

failed = False
for case in tests:
    *args, expected = case
    try:
        result = f(*args)
    except Exception as e:
        print("FAIL: py_number_base_converter(" + repr(args) + ") raised " + repr(e))
        failed = True
        continue
    if result != expected:
        print("FAIL: py_number_base_converter(" + repr(args) + ") = " + repr(result) + ", expected " + repr(expected))
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

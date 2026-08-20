#!/bin/bash
source ../../../main/colors.sh

expected_file="string_sculptor.py"
rendu_dir="../../../../rendu/string_sculptor"

if [ ! -f "$rendu_dir/$expected_file" ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: Missing file $expected_file$(tput sgr 0)"
    exit 1
fi

echo "${BLUE}Checking string_sculptor implementation...${RESET}"

python3 - "$rendu_dir" <<'PYEOF'
import importlib.util
import sys

rendu_dir = sys.argv[1] if len(sys.argv) > 1 else "."
spec = importlib.util.spec_from_file_location("string_sculptor", rendu_dir + "/string_sculptor.py")
module = importlib.util.module_from_spec(spec)
try:
    spec.loader.exec_module(module)
except Exception as e:
    print("FAIL: could not import string_sculptor.py -> " + str(e))
    sys.exit(1)

if not hasattr(module, "py_string_sculptor"):
    print("FAIL: function py_string_sculptor not found in string_sculptor.py")
    sys.exit(1)

f = getattr(module, "py_string_sculptor")

tests = [
    ("hello", "hElLo"),
    ("Hello World", "hElLo WoRlD"),
    ("aBc123def", "aBc123DeF"),
    ("Python3.9!", "pYtHoN3.9!"),
    ("", ""),
]

failed = False
for case in tests:
    *args, expected = case
    try:
        result = f(*args)
    except Exception as e:
        print("FAIL: py_string_sculptor(" + repr(args) + ") raised " + repr(e))
        failed = True
        continue
    if result != expected:
        print("FAIL: py_string_sculptor(" + repr(args) + ") = " + repr(result) + ", expected " + repr(expected))
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

#!/bin/bash
source ../../../main/colors.sh

expected_file="prism_detector.py"
rendu_dir="../../../../rendu/prism_detector"

if [ ! -f "$rendu_dir/$expected_file" ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: Missing file $expected_file$(tput sgr 0)"
    exit 1
fi

echo "${BLUE}Checking prism_detector implementation...${RESET}"

python3 - "$rendu_dir" <<'PYEOF'
import importlib.util
import sys

rendu_dir = sys.argv[1] if len(sys.argv) > 1 else "."
spec = importlib.util.spec_from_file_location("prism_detector", rendu_dir + "/prism_detector.py")
module = importlib.util.module_from_spec(spec)
try:
    spec.loader.exec_module(module)
except Exception as e:
    print("FAIL: could not import prism_detector.py -> " + str(e))
    sys.exit(1)

if not hasattr(module, "prism_detector"):
    print("FAIL: function prism_detector not found in prism_detector.py")
    sys.exit(1)

f = getattr(module, "prism_detector")

tests = [
    (["ABCD", "EFGH", "IJKL", "MNOP"], "AFKP", [(0, 0, 'D1')]),
    (["ABCD", "EFGH", "IJKL", "MNOP"], "ABCD", [(0, 0, 'H')]),
    (["ABCD", "EFGH", "IJKL", "MNOP"], "AEIM", [(0, 0, 'V')]),
    (["ABCD", "EFGH", "IJKL", "MNOP"], "XYZ", []),
    ([], "AB", []),
    (["ABCD", "EFGH", "IJKL", "MNOP"], "", []),
]

failed = False
for case in tests:
    *args, expected = case
    try:
        result = f(*args)
    except Exception as e:
        print("FAIL: prism_detector(" + repr(args) + ") raised " + repr(e))
        failed = True
        continue
    if result != expected:
        print("FAIL: prism_detector(" + repr(args) + ") = " + repr(result) + ", expected " + repr(expected))
        failed = True

if failed:
    sys.exit(1)
sys.exit(0)
PYEOF

if [ $? -ne 0 ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: one or more test cases failed$(tput sgr 0)"
    exit 1
fi

echo "$(tput setaf 2)$(tput bold)ALL TESTS PASSED!$(tput sgr 0)"
exit 0

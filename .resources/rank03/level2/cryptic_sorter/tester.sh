#!/bin/bash
source ../../../main/colors.sh

expected_file="cryptic_sorter.py"
rendu_dir="../../../../rendu/cryptic_sorter"

if [ ! -f "$rendu_dir/$expected_file" ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: Missing file $expected_file$(tput sgr 0)"
    exit 1
fi

echo "${BLUE}Checking cryptic_sorter implementation...${RESET}"

python3 - "$rendu_dir" <<'PYEOF'
import importlib.util
import sys

rendu_dir = sys.argv[1] if len(sys.argv) > 1 else "."
spec = importlib.util.spec_from_file_location("cryptic_sorter", rendu_dir + "/cryptic_sorter.py")
module = importlib.util.module_from_spec(spec)
try:
    spec.loader.exec_module(module)
except Exception as e:
    print("FAIL: could not import cryptic_sorter.py -> " + str(e))
    sys.exit(1)

if not hasattr(module, "py_cryptic_sorter"):
    print("FAIL: function py_cryptic_sorter not found in cryptic_sorter.py")
    sys.exit(1)

f = getattr(module, "py_cryptic_sorter")

tests = [
    (["apple", "cat", "banana", "dog", "elephant"], ['cat', 'dog', 'apple', 'banana', 'elephant']),
    (["aaa", "bbb", "AAA", "BBB"], ['aaa', 'AAA', 'bbb', 'BBB']),
    (["hello", "world", "hi", "test"], ['hi', 'test', 'hello', 'world']),
    ([], []),
    ([""], ['']),
]

failed = False
for case in tests:
    *args, expected = case
    try:
        result = f(*args)
    except Exception as e:
        print("FAIL: py_cryptic_sorter(" + repr(args) + ") raised " + repr(e))
        failed = True
        continue
    if result != expected:
        print("FAIL: py_cryptic_sorter(" + repr(args) + ") = " + repr(result) + ", expected " + repr(expected))
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

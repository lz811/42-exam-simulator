#!/bin/bash
source ../../../main/colors.sh

expected_file="word_ladder.py"
rendu_dir="../../../../rendu/word_ladder"

if [ ! -f "$rendu_dir/$expected_file" ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: Missing file $expected_file$(tput sgr 0)"
    exit 1
fi

echo "${BLUE}Checking word_ladder implementation...${RESET}"

python3 - "$rendu_dir" <<'PYEOF'
import importlib.util
import sys

rendu_dir = sys.argv[1] if len(sys.argv) > 1 else "."
spec = importlib.util.spec_from_file_location("word_ladder", rendu_dir + "/word_ladder.py")
module = importlib.util.module_from_spec(spec)
try:
    spec.loader.exec_module(module)
except Exception as e:
    print("FAIL: could not import word_ladder.py -> " + str(e))
    sys.exit(1)

if not hasattr(module, "word_ladder"):
    print("FAIL: function word_ladder not found in word_ladder.py")
    sys.exit(1)

f = getattr(module, "word_ladder")

tests = [
    ("hit", "cog", ["hot", "dot", "dog", "lot", "log", "cog"], 5),
    ("hit", "cog", ["hot", "dot", "dog", "lot", "log"], 0),
    ("hot", "dog", ["hot", "dog"], 0),
    ("same", "same", ["same"], 1),
    ("abc", "xyz", [], 0),
    ("cat", "cot", ["cot"], 2),
]

failed = False
for case in tests:
    *args, expected = case
    try:
        result = f(*args)
    except Exception as e:
        print("FAIL: word_ladder(" + repr(args) + ") raised " + repr(e))
        failed = True
        continue
    if result != expected:
        print("FAIL: word_ladder(" + repr(args) + ") = " + repr(result) + ", expected " + repr(expected))
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

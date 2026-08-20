#!/bin/bash
source ../../../main/colors.sh

expected_file="graph_cycle_detector.py"
rendu_dir="../../../../rendu/graph_cycle_detector"

if [ ! -f "$rendu_dir/$expected_file" ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: Missing file $expected_file$(tput sgr 0)"
    exit 1
fi

echo "${BLUE}Checking graph_cycle_detector implementation...${RESET}"

python3 - "$rendu_dir" <<'PYEOF'
import importlib.util
import sys

rendu_dir = sys.argv[1] if len(sys.argv) > 1 else "."
spec = importlib.util.spec_from_file_location("graph_cycle_detector", rendu_dir + "/graph_cycle_detector.py")
module = importlib.util.module_from_spec(spec)
try:
    spec.loader.exec_module(module)
except Exception as e:
    print("FAIL: could not import graph_cycle_detector.py -> " + str(e))
    sys.exit(1)

if not hasattr(module, "py_graph_cycle_detector"):
    print("FAIL: function py_graph_cycle_detector not found in graph_cycle_detector.py")
    sys.exit(1)

f = getattr(module, "py_graph_cycle_detector")

tests = [
    ({}, False),
    ({0: [1], 1: [2], 2: []}, False),
    ({0: [1], 1: [2], 2: [0]}, True),
    ({0: [1, 2], 1: [2], 2: []}, False),
    ({0: [1], 1: [0]}, True),
    ({0: []}, False),
    ({0: [1], 1: [], 2: [3], 3: [2]}, True),
    ({0: [1], 1: [], 2: [3], 3: []}, False),
]

failed = False
for case in tests:
    *args, expected = case
    try:
        result = f(*args)
    except Exception as e:
        print("FAIL: py_graph_cycle_detector(" + repr(args) + ") raised " + repr(e))
        failed = True
        continue
    if result != expected:
        print("FAIL: py_graph_cycle_detector(" + repr(args) + ") = " + repr(result) + ", expected " + repr(expected))
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

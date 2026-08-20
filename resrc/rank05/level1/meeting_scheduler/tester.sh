#!/bin/bash
source ../../../main/colors.sh

expected_file="meeting_scheduler.py"
rendu_dir="../../../../rendu/meeting_scheduler"

if [ ! -f "$rendu_dir/$expected_file" ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: Missing file $expected_file$(tput sgr 0)"
    exit 1
fi

echo "${BLUE}Checking meeting_scheduler implementation...${RESET}"

python3 - "$rendu_dir" <<'PYEOF'
import importlib.util
import sys

rendu_dir = sys.argv[1] if len(sys.argv) > 1 else "."
spec = importlib.util.spec_from_file_location("meeting_scheduler", rendu_dir + "/meeting_scheduler.py")
module = importlib.util.module_from_spec(spec)
try:
    spec.loader.exec_module(module)
except Exception as e:
    print("FAIL: could not import meeting_scheduler.py -> " + str(e))
    sys.exit(1)

if not hasattr(module, "schedule_meetings"):
    print("FAIL: function schedule_meetings not found in meeting_scheduler.py")
    sys.exit(1)

f = getattr(module, "schedule_meetings")

tests = [
    ([], (0, [])),
    ([(1, 5)], (1, [[(1, 5)]])),
    ([(1, 5), (5, 10)], (1, [[(1, 5), (5, 10)]])),
    ([(1, 5), (2, 6)], (2, [[(1, 5)], [(2, 6)]])),
    ([(1, 10), (2, 6), (6, 8), (15, 20)], (2, [[(1, 10), (15, 20)], [(2, 6), (6, 8)]])),
    ([(0, 30), (5, 10), (15, 20)], (2, [[(0, 30)], [(5, 10), (15, 20)]])),
]

failed = False
for case in tests:
    *args, expected = case
    try:
        result = f(*args)
    except Exception as e:
        print("FAIL: schedule_meetings(" + repr(args) + ") raised " + repr(e))
        failed = True
        continue
    if result != expected:
        print("FAIL: schedule_meetings(" + repr(args) + ") = " + repr(result) + ", expected " + repr(expected))
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

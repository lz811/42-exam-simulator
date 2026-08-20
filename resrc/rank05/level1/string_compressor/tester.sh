#!/bin/bash
source ../../../main/colors.sh

expected_file="string_compressor.py"
rendu_dir="../../../../rendu/string_compressor"

if [ ! -f "$rendu_dir/$expected_file" ]; then
    echo "$(tput setaf 1)$(tput bold)FAIL: Missing file $expected_file$(tput sgr 0)"
    exit 1
fi

echo "${BLUE}Checking string_compressor implementation...${RESET}"

python3 - "$rendu_dir" <<'PYEOF'
import importlib.util
import sys

rendu_dir = sys.argv[1] if len(sys.argv) > 1 else "."
spec = importlib.util.spec_from_file_location("string_compressor", rendu_dir + "/string_compressor.py")
module = importlib.util.module_from_spec(spec)
try:
    spec.loader.exec_module(module)
except Exception as e:
    print("FAIL: could not import string_compressor.py -> " + str(e))
    sys.exit(1)

failed = False

for func_name, tests in {
    "compress": [
        ("aaabbbccd", "a3b3c2d"),
        ("abcdef", "abcdef"),
        ("aaaaaaaaaa", "a10"),
        ("", ""),
        ("aabbccdd", "a2b2c2d2"),
    ],
    "decompress": [
        ("a3b3c2d", "aaabbbccd"),
        ("abcdef", "abcdef"),
        ("a10", "aaaaaaaaaa"),
        ("", ""),
        ("a2b2c2d2", "aabbccdd"),
    ],
}.items():
    if not hasattr(module, func_name):
        print("FAIL: function " + func_name + " not found in string_compressor.py")
        failed = True
        continue
    f = getattr(module, func_name)
    for case in tests:
        *args, expected = case
        try:
            result = f(*args)
        except Exception as e:
            print("FAIL: " + func_name + "(" + repr(args) + ") raised " + repr(e))
            failed = True
            continue
        if result != expected:
            print("FAIL: " + func_name + "(" + repr(args) + ") = " + repr(result) + ", expected " + repr(expected))
            failed = True

# Round-trip check: decompress(compress(x)) == x
if hasattr(module, "compress") and hasattr(module, "decompress"):
    for original in ["aaabbbccd", "abcdef", "aaaaaaaaaa", "", "aabbccdd", "zzzzzzzzzzzzzz"]:
        try:
            roundtrip = module.decompress(module.compress(original))
        except Exception as e:
            print("FAIL: round-trip on " + repr(original) + " raised " + repr(e))
            failed = True
            continue
        if roundtrip != original:
            print("FAIL: round-trip decompress(compress(" + repr(original) + ")) = " + repr(roundtrip))
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

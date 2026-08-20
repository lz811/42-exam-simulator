#!/usr/bin/env python3
def py_bracket_validator(s: str) -> bool:
    stack = []
    pairs = {")": "(", "]": "[", "}": "{"}
    for char in s:
        if char in "([{":
            stack.append(char)
        elif char in ")]}":
            if not stack or pairs[char] != stack[-1]:
                return False
            stack.pop()
    return len(stack) == 0


def main() -> None:
    print(py_bracket_validator("()"))  # True
    print(py_bracket_validator("()[]{}"))  # True
    print(py_bracket_validator("(]"))  # False
    print(py_bracket_validator("([)]"))  # False
    print(py_bracket_validator("{[]}"))  # True
    print(py_bracket_validator("hello(world)[test]{code}"))  # True
    print(py_bracket_validator("((()))"))  # True
    print(py_bracket_validator("((())"))  # False
    print(py_bracket_validator(""))  # True


if __name__ == "__main__":
    main()

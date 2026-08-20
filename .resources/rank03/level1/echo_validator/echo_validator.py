#!/usr/bin/env python3
def py_echo_validator(text: str) -> bool:
    filtered = [c.lower() for c in text if c.isalpha()]
    if not filtered:
        return False
    return filtered == filtered[::-1]


def main() -> None:
    print(py_echo_validator("racecar"))  # True
    print(py_echo_validator("A man a plan a canal Panama"))  # True
    print(py_echo_validator("race a car"))  # False
    print(py_echo_validator("Was it a car or a cat I saw"))  # True
    print(py_echo_validator("hello"))  # False
    print(py_echo_validator("Madam Im Adam"))  # True
    print(py_echo_validator(""))  # False


if __name__ == "__main__":
    main()

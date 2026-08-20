#!/usr/bin/env python3
def py_string_permutation_checker(s1: str, s2: str) -> bool:
    return sorted(s1) == sorted(s2)


def main() -> None:
    print(py_string_permutation_checker("abc", "bca"))                 # True
    print(py_string_permutation_checker("abc", "def"))                 # False
    print(py_string_permutation_checker("listen", "silent"))           # True
    print(py_string_permutation_checker("hello", "bello"))             # False
    print(py_string_permutation_checker("", ""))                       # True
    print(py_string_permutation_checker("a", ""))                      # False
    print(py_string_permutation_checker("Abc", "abc"))                 # False
    print(py_string_permutation_checker("a gentleman", "elegant man")) # True


if __name__ == "__main__":
    main()

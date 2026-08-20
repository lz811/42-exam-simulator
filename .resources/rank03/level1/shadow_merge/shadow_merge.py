#!/usr/bin/env python3
def py_shadow_merge(list1: list[int], list2: list[int]) -> list[int]:
    merged = list1 + list2
    merged.sort()
    return merged


def main() -> None:
    print(py_shadow_merge([1, 3, 5], [2, 4, 6]))  # [1, 2, 3, 4, 5, 6]
    print(py_shadow_merge([1, 2, 3], [4, 5, 6]))  # [1, 2, 3, 4, 5, 6]
    print(py_shadow_merge([1], [2, 3, 4]))  # [1, 2, 3, 4]
    print(py_shadow_merge([], [1, 2, 3]))  # [1, 2, 3]
    print(py_shadow_merge([1, 1, 2], [1, 3, 3]))  # [1, 1, 1, 2, 3, 3]


if __name__ == "__main__":
    main()

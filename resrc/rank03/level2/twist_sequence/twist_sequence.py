#!/usr/bin/env python3
def py_twist_sequence(arr: list[int], k: int) -> list[int]:
    if not arr:
        return []
    k = k % len(arr)
    if k == 0:
        return list(arr)
    return arr[-k:] + arr[:-k]


def main() -> None:
    print(py_twist_sequence([1, 2, 3, 4, 5], 2))  # [4, 5, 1, 2, 3]
    print(py_twist_sequence([1, 2, 3], 1))  # [3, 1, 2]
    print(py_twist_sequence([1, 2, 3, 4], 0))  # [1, 2, 3, 4]
    print(py_twist_sequence([1, 2, 3], 5))  # [2, 3, 1]
    print(py_twist_sequence([], 3))  # []


if __name__ == "__main__":
    main()

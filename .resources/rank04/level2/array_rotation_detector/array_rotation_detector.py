#!/usr/bin/env python3
def array_rotation_detector(arr1: list[int], arr2: list[int]) -> bool:
    if len(arr1) != len(arr2):
        return False
    if not arr1:
        return True
    n = len(arr1)
    doubled = arr1 + arr1
    return any(doubled[i:i+n] == arr2 for i in range(n))


def main() -> None:
    print(array_rotation_detector([1, 2, 3, 4, 5], [3, 4, 5, 1, 2]))  # True
    print(array_rotation_detector([1, 2, 3], [3, 2, 1]))              # False


if __name__ == "__main__":
    main()

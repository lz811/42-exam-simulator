#!/usr/bin/env python3
def list_intersection_finder(lists: list[list[int]]) -> list[int]:
    if not lists or any(not lst for lst in lists):
        return []
    return sorted(set.intersection(*map(set, lists)))


def main() -> None:
    print(list_intersection_finder([[1, 2, 3], [2, 3, 4], [2, 5]]))  # [2]


if __name__ == "__main__":
    main()

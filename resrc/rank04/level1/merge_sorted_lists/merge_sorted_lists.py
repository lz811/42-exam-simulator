#!/usr/bin/env python3
def merge_sorted_lists(lists: list[list[int]]) -> list[int]:
    out = []
    for lst in lists:
        for n in lst:
            out.append(n)
    return sorted(out)


def main() -> None:
    print(merge_sorted_lists([[1, 3, 5], [2, 4, 6]]))  # [1, 2, 3, 4, 5, 6]


if __name__ == "__main__":
    main()

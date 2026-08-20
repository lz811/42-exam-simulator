#!/usr/bin/env python3
def py_mirror_matrix(matrix: list[list[int]]) -> list[list[int]]:
    return [row[::-1] for row in matrix]


def main() -> None:
    print(py_mirror_matrix([[1, 2, 3], [4, 5, 6]]))  # [[3, 2, 1], [6, 5, 4]]
    print(py_mirror_matrix([[1, 2], [3, 4], [5, 6]]))  # [[2, 1], [4, 3], [6, 5]]
    print(py_mirror_matrix([[7]]))  # [[7]]
    print(py_mirror_matrix([[1, 2, 3, 4]]))  # [[4, 3, 2, 1]]


if __name__ == "__main__":
    main()

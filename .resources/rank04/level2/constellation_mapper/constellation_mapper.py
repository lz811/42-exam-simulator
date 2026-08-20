#!/usr/bin/env python3
def constellation_mapper(stars: list[tuple[int, int]], size: int) -> list[str]:
    star_set = set(stars)
    grid = []
    for r in range(size):
        row = ""
        for c in range(size):
            if (r, c) in star_set:
                row += "*"
            else:
                row += "."
        grid.append(row)
    return grid


def main() -> None:
    print(constellation_mapper([(0, 0), (1, 1)], 3))  # ['*..', '.*.', '...']


if __name__ == "__main__":
    main()

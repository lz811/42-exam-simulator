def prism_detector(grid: list[str], pattern: str):
    if not grid or not pattern:
        return []
    h = len(grid)
    w = len(grid[0])
    directions = [
        (1, 0, "H"),
        (-1, 0, "H-"),
        (0, 1, "V"),
        (0, -1, "V-"),
        (1, 1, "D1"),
        (-1, -1, "D1-"),
        (-1, 1, "D2"),
        (1, -1, "D2-"),
    ]
    okay = []
    for x in range(w):
        for y in range(h):
            for dx, dy, name in directions:
                ok = True
                for i in range(len(pattern)):
                    nx = x + dx * i
                    ny = y + dy * i
                    if (
                        nx < 0
                        or ny < 0
                        or nx >= w
                        or ny >= h
                        or grid[ny][nx] != pattern[i]
                    ):
                        ok = False
                        break
                if ok:
                    okay.append((x, y, name))
    return okay

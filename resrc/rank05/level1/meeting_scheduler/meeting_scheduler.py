def schedule_meetings(intervals: list[tuple[int, int]]) -> tuple[int, list]:
    if not intervals:
        return 0, []
    intervals = sorted(intervals, key=lambda x: x[0])
    rooms = []
    for start, end in intervals:
        placed = False
        for room in rooms:
            if room[-1][1] <= start:
                room.append((start, end))
                placed = True
                break
        if not placed:
            rooms.append([(start, end)])
    return len(rooms), rooms

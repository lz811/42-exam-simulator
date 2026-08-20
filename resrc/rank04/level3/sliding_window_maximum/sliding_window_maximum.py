#!/usr/bin/env python3
def sliding_window_maximum(nums: list[int], k: int) -> list[int]:
    if not nums or k <= 0 or k > len(nums):
        return []
    return (max(nums[i:i+k]) for i in range(len(nums) - k + 1))


def main() -> None:
    print(list(sliding_window_maximum([1, 3, -1, -3, 5, 3, 6, 7], 3)))  # [3, 3, 5, 5, 6, 7]


if __name__ == "__main__":
    main()

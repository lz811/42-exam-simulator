#!/usr/bin/env python3
def palindrome_partitioner(s: str) -> int:
    if not s:
        return 0
    n = len(s)
    dp = list(range(n))
    for i in range(n):
        for j in range(i + 1):
            if s[j:i+1] == s[j:i+1][::-1]:
                dp[i] = 0 if j == 0 else min(dp[i], dp[j-1] + 1)
    return dp[-1]


def main() -> None:
    print(palindrome_partitioner("aab"))  # 1


if __name__ == "__main__":
    main()

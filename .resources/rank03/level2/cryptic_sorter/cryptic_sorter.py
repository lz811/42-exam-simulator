#!/usr/bin/env python3
def py_cryptic_sorter(strings: list[str]) -> list[str]:
    def vowel_count(s):
        return sum(1 for c in s if c in "aeiouAEIOU")
    return sorted(strings, key=lambda s: (len(s), s.lower(), vowel_count(s)))


def main() -> None:
    print(py_cryptic_sorter(["apple", "cat", "banana", "dog", "elephant"]))
    # ['cat', 'dog', 'apple', 'banana', 'elephant']
    print(py_cryptic_sorter(["aaa", "bbb", "AAA", "BBB"]))
    # ['AAA', 'aaa', 'BBB', 'bbb']
    print(py_cryptic_sorter(["hello", "world", "hi", "test"]))
    # ['hi', 'test', 'hello', 'world']
    print(py_cryptic_sorter([]))  # []
    print(py_cryptic_sorter([""]))  # ['']


if __name__ == "__main__":
    main()

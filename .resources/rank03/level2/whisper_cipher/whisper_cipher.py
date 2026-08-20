#!/usr/bin/env python3
def py_whisper_cipher(text: str, shift: int) -> str:
    shift %= 26

    def shift_char(c):
        if "a" <= c <= "z":
            return chr((ord(c) - ord("a") + shift) % 26 + ord("a"))
        if "A" <= c <= "Z":
            return chr((ord(c) - ord("A") + shift) % 26 + ord("A"))
        return c
    return "".join(map(shift_char, text))


def main() -> None:
    print(py_whisper_cipher("hello", 3))  # "khoor"
    print(py_whisper_cipher("Hello World!", 1))  # "Ifmmp Xpsme!"
    print(py_whisper_cipher("xyz", 3))  # "abc"
    print(py_whisper_cipher("ABC123def", 5))  # "FGH123ijk"
    print(py_whisper_cipher("", 10))  # ""


if __name__ == "__main__":
    main()

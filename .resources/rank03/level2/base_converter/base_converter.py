#!/usr/bin/env python3
def py_number_base_converter(number: str, from_base: int, to_base: int) -> str:
    digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    try:
        if not (2 <= from_base <= 36 and 2 <= to_base <= 36):
            return "ERROR"
        decimal = int(number, from_base)
    except ValueError:
        return "ERROR"
    if decimal == 0:
        return "0"
    result = ""
    while decimal > 0:
        result = digits[decimal % to_base] + result
        decimal //= to_base
    return result


def main() -> None:
    print(py_number_base_converter("1010", 2, 10))  # "10"
    print(py_number_base_converter("FF", 16, 10))  # "255"
    print(py_number_base_converter("255", 10, 16))  # "FF"
    print(py_number_base_converter("123", 10, 2))  # "1111011"
    print(py_number_base_converter("Z", 36, 10))  # "35"
    print(py_number_base_converter("35", 10, 36))  # "Z"
    print(py_number_base_converter("123", 1, 10))  # "ERROR"
    print(py_number_base_converter("G", 16, 10))  # "ERROR"


if __name__ == "__main__":
    main()

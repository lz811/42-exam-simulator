#!/usr/bin/env python3
def package_dependency_resolver(packages: dict[str, list[str]]) -> list[str]:
    if not packages:
        return []
    deps = {}
    for name, dependencies in packages.items():
        deps[name] = [d for d in dependencies if d in packages]

    in_degree = {name: len(d) for name, d in deps.items()}

    queue = sorted(name for name, deg in in_degree.items() if deg == 0)
    result = []

    while queue:
        next_queue = []
        for current in queue:
            result.append(current)
            for name, dependencies in deps.items():
                if current in dependencies:
                    in_degree[name] -= 1
                    if in_degree[name] == 0:
                        next_queue.append(name)
        queue = sorted(next_queue)

    if len(result) != len(packages):
        return []
    return result


def main() -> None:
    print(package_dependency_resolver({"a": [], "b": ["a"], "c": ["a", "b"]}))  # ['a', 'b', 'c']


if __name__ == "__main__":
    main()

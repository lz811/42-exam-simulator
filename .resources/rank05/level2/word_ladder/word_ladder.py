def word_ladder(start: str, end: str, sentence: list[str]) -> int:
    mots = set(sentence)
    niveau = [start]
    longueur = 1
    vus = {start}
    while niveau:
        suivant = []
        for mot in niveau:
            if mot == end:
                return longueur
            for i in range(len(mot)):
                for c in "abcdefghijklmnopqrstuvwxyz":
                    voisin = mot[:i] + c + mot[i+1:]
                    if voisin in mots and voisin not in vus:
                        vus.add(voisin)
                        suivant.append(voisin)
        niveau = suivant
        longueur += 1
    return 0

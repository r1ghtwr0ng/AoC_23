import numpy as np

card_order = np.array(['J', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'Q', 'K', 'A']) # Part 2 ordering

def solve(data):
    rounds = data.strip().split("\n")
    based = np.empty((len(rounds), 7), dtype='uint32')
    for i, round in enumerate(rounds):
        [hand, bet] = round.split()
        based[i][:-1] = get_orderings(hand)
        based[i][-1] = int(bet)

    sorted_arr = sorted(based, key=lambda x: tuple(x[:6]))
    count = 0
    for i in range(len(sorted_arr)):
        count += (i+1) * sorted_arr[i][-1]
    return count

def get_orderings(hand):
    hand = np.array(list(hand))
    sorting = np.empty(len(hand) + 1, dtype='uint32')
    for i, card in enumerate(hand):
        sorting[i+1] = np.where(card_order == card)[0][0]

    cards, counts = np.unique(hand, return_counts=True)
    # Part 2 code, just ditch this bit of code if trying to do part 1.
    joker_idx = np.where(cards == 'J')
    if joker_idx[0].size > 0:
        cock = counts
        value = counts[joker_idx[0][0]]
        if value != 5:
            counts = np.delete(counts, joker_idx[0][0])
            update_idx = np.argmax(counts)
            counts[update_idx] += value

    sorting[0] = get_primary(np.sort(counts))
    return sorting

# What this function does is left as exercise to the reader
def get_primary(row):
    padding = 5 - len(row)
    if padding > 0:
        row = np.pad(row, (0, padding), mode='constant')
    matrix = np.array([
        [1, 1, 1, 1, 1],
        [1, 1, 1, 2, 0],
        [1, 2, 2, 0, 0],
        [1, 1, 3, 0, 0],
        [2, 3, 0, 0, 0],
        [1, 4, 0, 0, 0],
        [5, 0, 0, 0, 0],
    ])
    rank = np.where((matrix == row).all(axis=1))[0][0]
    return rank

def main():
    filename = "input_files/input7.txt"
    with open(filename) as f:
        data = f.read()
        f.close()
    print(f"[+] Solution: {solve(data)}")

if __name__ == '__main__':
    main()
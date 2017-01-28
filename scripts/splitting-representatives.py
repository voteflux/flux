"""
This simulates splitting representatives for a given vote split from a larger population.

Say a population of 100 people votes 65 for, 35 against some measure.
However, that population only has N representatives.

How should those N representatives be split in order to represent the voting population best?
"""


import math


split_point = 0.65


def splits(split_point, n_reps):
    perfect_n = split_point * n_reps
    return (math.floor(perfect_n), math.ceil(perfect_n))


# print splits as seats (e.g. 7 reps might be split 5-2)
ps = lambda n_reps, s: '%2d-%2d' % (s, n_reps - s)


def print_row(n_reps, ls, ld, hs, hd):
    print('%02s' % n_reps, ps(n_reps, ls), '%5.2f' % round(ld, 2), ps(n_reps, hs), '%5.2f' % round(hd, 2), sep=' | ')


def potential_splits(split_point, n_max=20, should_print=True):
    bias_majority = 0
    for n_reps in range(1, n_max + 1):
        ls, hs = splits(split_point, n_reps)
        disempowerments = (split_point - ls/n_reps, hs/n_reps - split_point)
        if should_print:
            print_row(n_reps, ls, disempowerments[0] * 100, hs, disempowerments[1] * 100)
        bias_majority += 1 if disempowerments[1] < disempowerments[0] else 0
    if should_print:
        print("Majority biased %5.2f%% of time" % (bias_majority / n_max * 100,))
    return bias_majority


def print_table_of_splits():
    potential_splits(split_point, 20, True)


def print_reps_to_majority_bias():
    for i in range(1, 30):
        print("%02d -> %05.2f" % (i, potential_splits(split_point, i, False) / i * 100))


if __name__ == "__main__":
    print_table_of_splits()

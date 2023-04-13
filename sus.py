def calc_sus(response: list[int]):
    score = 0

    # contrib score for 1 , 3, 5, 7 and 9 is score - 1:
    
    contrib_one_indexes = [0, 2, 4, 6, 8]

    for i in contrib_one_indexes:
        score += (response[i]-1)


    # contrib score for 2, 4, 6, 8 and 10 has score 5 minus response


    contrib_two_indexes = [1, 3, 5, 7, 9]

    for i in contrib_two_indexes:
        score += (5 - response[i])

    score = score*2.5

    print(score)

    return score


calc_sus([4, 2, 4, 1, 3, 4, 4, 2, 5, 1])
calc_sus([4, 2, 4, 2, 4, 5, 4, 1, 4, 1])
calc_sus([5, 1, 5, 1, 3, 4, 5, 1, 5, 1])
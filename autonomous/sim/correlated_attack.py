import random

def correlated_bribery_trial(
    n=50, 
    byz_frac=0.3, 
    quorum=2/3, 
    p_detect=0.95, 
    slash=0.6, 
    campaign_prob=0.1, 
    normal_bribe=0.05, 
    campaign_bribe=0.4
):
    stake = [1 for _ in range(n)]
    total = sum(stake)
    byz = set(random.sample(range(n), int(n * byz_frac)))

    bribed = set()
    campaign_active = random.random() < campaign_prob

    for i in range(n):
        if i in byz:
            continue

        bribe_offer = campaign_bribe if campaign_active else normal_bribe

        # Probabilistic bribery acceptance: 
        # higher bribe relative to expected slash => more likely to defect
        denom = (p_detect * slash)
        accept_prob = 0.0 if denom <= 0 else max(0.0, min(1.0, bribe_offer / denom))

        if random.random() < accept_prob:
            bribed.add(i)

    compromised_stake = sum(stake[i] for i in (byz | bribed))
    return 1 if compromised_stake >= (quorum * total) else 0

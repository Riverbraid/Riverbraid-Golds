import sys
import math
import random
from sim.monte_carlo import run_partition_trials
from sim.correlated_attack import correlated_bribery_trial

random.seed(1337)

def wilson_upper_bound(p_hat, n, z=1.96):
    if n == 0: return 1.0
    denominator = 1 + z**2/n
    centre_adj_p = p_hat + z**2/(2*n)
    adj_p_variance = z * math.sqrt(max(0, (p_hat*(1-p_hat) + z**2/(4*n))/n))
    return (centre_adj_p + adj_p_variance) / denominator

MAX_PARTITION_FAIL = 0.01  
MAX_BRIBERY_SUCCESS = 0.02 

QUORUM = 0.75
SLASH = 0.9
BYZ = 0.3
TRIALS = 1000

p_raw = run_partition_trials(trials=TRIALS, byz_frac=BYZ, quorum=QUORUM)
b_raw = sum(correlated_bribery_trial(slash=SLASH, quorum=QUORUM, byz_frac=BYZ) for _ in range(TRIALS)) / TRIALS

p_upper = wilson_upper_bound(p_raw, TRIALS)
b_upper = wilson_upper_bound(b_raw, TRIALS)

print(f"[AUDIT] Partition Risk: Raw={p_raw:.4f}, Upper95={p_upper:.4f}")
print(f"[AUDIT] Bribery Risk:   Raw={b_raw:.4f}, Upper95={b_upper:.4f}")

if p_upper > MAX_PARTITION_FAIL or b_upper > MAX_BRIBERY_SUCCESS:
    print("[FAIL-CLOSED] Risk (including confidence bound) exceeds thresholds.")
    sys.exit(1)

print(f"[PASS] Sovereign Stability Locked at Quorum={QUORUM}")

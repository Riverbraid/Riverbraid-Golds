import random

class GovernanceSystem:
    def __init__(self, n=50, byz_frac=0.3, quorum=0.75):
        self.n = n
        self.quorum = quorum
        self.stake = [random.uniform(0.5, 1.5) for _ in range(n)]
        self.total = sum(self.stake)
        self.byz = set(random.sample(range(n), int(n * byz_frac)))

    def stake_sum(self, indices):
        return sum(self.stake[i] for i in indices)

    def finalize(self, voters):
        return self.stake_sum(voters) >= self.quorum * self.total

    def double_finalize_attempt(self):
        honest = [i for i in range(self.n) if i not in self.byz]
        half = len(honest)//2
        R = set(honest[:half]) | self.byz
        Rp = set(honest[half:]) | self.byz
        return self.finalize(R) and self.finalize(Rp)

def run_partition_trials(trials=1000, byz_frac=0.3, quorum=0.75):
    failures = 0
    for _ in range(trials):
        sim = GovernanceSystem(byz_frac=byz_frac, quorum=quorum)
        if sim.double_finalize_attempt():
            failures += 1
    return failures / trials

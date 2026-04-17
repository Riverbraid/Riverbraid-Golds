# Disaster Recovery Protocol (Cold Start)
1. **Source**: Clone all 23 repositories from the `Riverbraid` organization.
2. **Anchor**: Begin with `Riverbraid-Core` to establish the `run-vectors.cjs` truth.
3. **Verification**: Execute `./verify-all.sh` from this repository.
4. **Validation**: The resulting Merkle Root must match `de20625f9b8c7d1e8ec84f6d8f86d9f4f2b083a4`.
5. **Fail-Closed**: If any hash mismatch occurs, the reconstruction is considered compromised.

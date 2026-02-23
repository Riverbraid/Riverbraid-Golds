#!/bin/bash
# @linear
echo "--- STARTING INSTITUTIONAL INTEGRITY AUDIT ---"
NODE_VERSION=$(node -v)
if [[ $NODE_VERSION != v20* ]]; then
  echo "FATAL: Node version $NODE_VERSION does not match Institutional Standard v20.x"
  exit 1
fi
python3 gate2_byte_audit.py && \
python3 gate3_entropy_scan.py && \
python3 gate4_generate_seal.py && \
python3 gate5_coherence_check.py && \
python3 gate6_invariant_validator.py
if [ $? -eq 0 ]; then
  echo "--- CLUSTER_VERIFIED_STATIONARY ---"
  cat /workspaces/TRUTH.SEAL.sha256
else
  echo "--- VERIFICATION_FAILED ---"
  exit 1
fi

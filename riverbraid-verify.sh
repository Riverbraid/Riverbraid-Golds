#!/bin/bash
echo "--- STARTING INSTITUTIONAL INTEGRITY AUDIT ---"
python3 gate2_byte_audit.py && \
python3 gate3_entropy_scan.py && \
python3 gate4_generate_seal.py && \
python3 gate5_coherence_check.py && \
python3 gate6_invariant_validator.py

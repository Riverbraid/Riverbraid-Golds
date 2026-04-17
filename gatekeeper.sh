#!/bin/bash
# Absolute V2 Linear Gate: Hygiene -> Assemble -> Build -> Vectors

echo "--- STEP 1: HYGIENE CHECK ---"
find /workspaces -name "node_modules" -type d -prune -o -name "*.log" -print | xargs rm -rf 2>/dev/null

echo "--- STEP 2: ASSEMBLE ---"
./cold-start.sh > /dev/null

echo "--- STEP 3: BUILD/VERIFY ---"
# We execute a focused check on the Core to set the session vector
VERIFICATION_SIGNAL=$(cd /workspaces/Riverbraid-Core && node run-vectors.cjs verify)

echo "--- STEP 4: VECTOR ALIGNMENT ---"
if [[ "$VERIFICATION_SIGNAL" == *"SIGNAL_STATIONARY_MATCH"* ]]; then
  echo "Entropy-Equilibrium Reached: TRUE"
  exit 0
else
  echo "Entropy-Equilibrium Reached: FALSE"
  echo "DEBUG: $VERIFICATION_SIGNAL"
  exit 1
fi

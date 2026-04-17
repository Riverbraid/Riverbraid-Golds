#!/bin/bash
# Absolute V2 Linear Gate: Hygiene -> Assemble -> Build -> Vectors

echo "--- STEP 1: HYGIENE CHECK ---"
find /workspaces -name "node_modules" -type d -prune -o -name "*.log" -print | xargs rm -rf

echo "--- STEP 2: ASSEMBLE ---"
./cold-start.sh

echo "--- STEP 3: BUILD/VERIFY ---"
./verify-all.sh

echo "--- STEP 4: VECTOR ALIGNMENT ---"
node -e "console.log('Entropy-Equilibrium Reached: ' + (process.exitCode === 0 ? 'TRUE' : 'FALSE'))"

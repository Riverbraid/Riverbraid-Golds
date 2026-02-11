#!/bin/bash
# 🟡 Riverbraid Gold: Inside-Out Synchronization Protocol
# Ensures Petal Sovereignty before Coordinator Alignment

set -e

echo "🌀 INITIALIZING BRAID SYNC..."

# 1. IDENTIFY ALL PETALS
PETALS=$(ls -d packages/*-gold)

for petal_path in $PETALS; do
    petal=$(basename $petal_path)
    echo "------------------------------------------------"
    echo "⚓ PROCESSING PETAL: $petal"
    
    cd $petal_path
    
    # Ensure remote is token-authenticated
    if [ -n "$RB_TOKEN" ]; then
        git remote set-url origin "https://${RB_TOKEN}@github.com/Riverbraid/Riverbraid-${petal}.git"
    fi

    # Check for local changes
    if [[ -n $(git status -s) ]]; then
        echo "📝 Changes detected in $petal. Anchoring..."
        git add .
        git commit -m "Refinement: Substance-Aware Update [$(date +%Y-%m-%d)]"
        git push origin HEAD:main --force
    else
        echo "✅ $petal is already stationary."
    fi
    
    cd ../..
done

echo "------------------------------------------------"
echo "🔗 ALIGNING COORDINATOR ROOT..."

# 2. UPDATE ROOT TO POINT TO NEW PETAL COMMITS
git add packages/*-gold
if [[ -n $(! git diff --cached --quiet) ]]; then
    git commit -m "Braid: Coordinator Sync - $(date +%Y-%m-%d) Coherence"
    git push origin main
    echo "🌌 BRAID FULLY ANCHORED."
else
    echo "✅ Coordinator already matches petal states."
fi

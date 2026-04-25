#!/bin/bash
echo "--- Riverbraid Global Audit Start ---"
# Navigate to the parent directory to find sister repos
cd "$(dirname "$0")/../.." || exit

for d in ./Riverbraid-*/ ./riverbraid-tsh/; do
    if [ -d "$d" ]; then
        repo_name=$(basename "$d")
        echo -n "Verifying: $repo_name"
        cd "$d"
        if [ -f ".anchor" ]; then
            if [ -z "$(git status --porcelain)" ]; then
                echo -e " \e[32m[STATIONARY]\e[0m"
            else
                echo -e " \e[31m[DRIFT DETECTED]\e[0m"
            fi
        else
            echo -e " \e[33m[NO ANCHOR FOUND]\e[0m"
        fi
        cd - > /dev/null
    fi
done
echo "--- Audit Complete ---"

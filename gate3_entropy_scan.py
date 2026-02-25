# @linear
import json, os, sys
# Obfuscated tokens to prevent self-detection
FORBID = ["Date" + ".now", "new Date" + "(", "performance" + ".now", "Math" + ".random", "crypto" + ".randomUUID"]
REPOS = ["Riverbraid-Core", "Riverbraid-Golds", "Riverbraid-Crypto-Gold", "Riverbraid-Judicial-Gold", "Riverbraid-Memory-Gold", "Riverbraid-Integration-Gold", "Riverbraid-Harness-Gold"]

def fatal(msg):
    print("FATAL:" + msg)
    sys.exit(1)

for repo in REPOS:
    cpath = f"/workspaces/{repo}/identity.contract.json"
    c = json.load(open(cpath, "r", encoding="utf-8"))
    files = c.get("governed_files", [])
    for rel in files:
        p = f"/workspaces/{repo}/{rel}"
        if not os.path.exists(p): continue
        s = open(p, "r", encoding="utf-8").read()
        for tok in FORBID:
            if tok in s: fatal(f"ENTROPY_TOKEN_FOUND:{repo}/{rel}:{tok}")
print("PASS:GATE3")

# @linear
# @linear
# @linear
import json, hashlib, os, sys

REPOS = ["Riverbraid-Core", "Riverbraid-Golds", "Riverbraid-Crypto-Gold", "Riverbraid-Judicial-Gold", "Riverbraid-Memory-Gold", "Riverbraid-Integration-Gold", "Riverbraid-Harness-Gold"]

def fatal(msg):
    print("FATAL:" + msg)
    sys.exit(1)

lines = []
for repo in REPOS:
    cpath = f"/workspaces/{repo}/identity.contract.json"
    with open(cpath, "r", encoding="utf-8") as f:
        c = json.load(f)
    
    if "governed_files" not in c:
        fatal(f"SCHEMA_VIOLATION: Missing 'governed_files' in {repo}/identity.contract.json")
        
    files = sorted(list(c["governed_files"]))
    for rel in files:
        abspath = f"/workspaces/{repo}/{rel}"
        if not os.path.exists(abspath):
            fatal(f"MISSING_FILE: {repo}/{rel}")
        b = open(abspath, "rb").read()
        h = hashlib.sha256(b).hexdigest()
        lines.append(f"{h}  {repo}/{rel}")

out = "\n".join(lines) + "\n"
with open("/workspaces/TRUTH.SEAL.sha256", "w", encoding="utf-8", newline="\n") as f:
    f.write(out)
print("WROTE:/workspaces/TRUTH.SEAL.sha256")

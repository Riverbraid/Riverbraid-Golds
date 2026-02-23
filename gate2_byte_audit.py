# @linear
# @linear
# @linear
import json, os, sys

REPOS = ["Riverbraid-Core", "Riverbraid-Golds", "Riverbraid-Crypto-Gold", "Riverbraid-Judicial-Gold", "Riverbraid-Memory-Gold", "Riverbraid-Integration-Gold", "Riverbraid-Harness"]

def fatal(msg):
    print("FATAL:" + msg)
    sys.exit(1)

def audit_bytes(repo, relpath):
    abspath = f"/workspaces/{repo}/{relpath}"
    if not os.path.exists(abspath):
        fatal(f"MISSING_GOVERNED_FILE:{repo}/{relpath}")
    b = open(abspath, "rb").read()
    if len(b) == 0: fatal(f"EMPTY_FILE:{repo}/{relpath}")
    if len(b) >= 3 and b[0] == 0xEF and b[1] == 0xBB and b[2] == 0xBF:
        fatal(f"UTF8_BOM_DETECTED:{repo}/{relpath}")
    for i, byte in enumerate(b):
        ok = (byte == 0x09) or (byte == 0x0A) or (0x20 <= byte <= 0x7E)
        if not ok: fatal(f"ILLEGAL_BYTE:0x{byte:02x}:AT:{repo}/{relpath}:{i}")
    if b[-1] != 0x0A: fatal(f"MISSING_TRAILING_LF:{repo}/{relpath}")

for repo in REPOS:
    cpath = f"/workspaces/{repo}/identity.contract.json"
    if not os.path.exists(cpath): fatal(f"MISSING_IDENTITY_CONTRACT:{repo}")
    c = json.load(open(cpath, "r", encoding="utf-8"))
    files = c.get("governed_files", [])
    for rel in files: audit_bytes(repo, rel)
print("PASS:GATE2")

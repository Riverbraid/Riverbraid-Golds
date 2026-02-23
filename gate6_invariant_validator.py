# @linear
import json, sys, os
REPOS = ['Riverbraid-Core', 'Riverbraid-Golds', 'Riverbraid-Crypto-Gold', 'Riverbraid-Judicial-Gold', 'Riverbraid-Memory-Gold', 'Riverbraid-Integration-Gold', 'Riverbraid-Harness']
def fatal(msg): print(f'FATAL:INVARIANT_VIOLATION:{msg}'); sys.exit(1)
print('STARTING GATE 6: INVARIANT VALIDATION')
for r in REPOS:
    c_p = f'/workspaces/{r}/identity.contract.json'
    if not os.path.exists(c_p): fatal(f'Missing contract in {r}')
    with open(c_p, 'r') as f: c = json.load(f)
    if c.get('role') == 'FROZEN_CORE':
        p_p = f'/workspaces/{r}/package.json'
        if os.path.exists(p_p):
            with open(p_p, 'r') as f: pkg = json.load(f)
            if pkg.get('dependencies'): fatal(f'{r} (FROZEN_CORE) has dependencies')
    files = c.get('governed_files', [])
    for rel in files:
        f_p = f'/workspaces/{r}/{rel}'
        if rel.endswith(('.js', '.py')) and os.path.exists(f_p):
            with open(f_p, 'r') as f: head = f.read(100)
            if not any(tag in head.lower() for tag in ['@linear', '@nonlinear']):
                print(f'WARN: Missing @linear/@nonlinear in {r}/{rel}')
    if 'Stationary' not in str(c.get('invariants', [])):
        fatal(f'{r} missing Stationary invariant')
print('PASS:GATE 6')

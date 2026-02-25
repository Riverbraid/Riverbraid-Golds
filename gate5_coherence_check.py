# @linear
import json, sys, os
REPOS = ['Riverbraid-Core', 'Riverbraid-Golds', 'Riverbraid-Crypto-Gold', 'Riverbraid-Judicial-Gold', 'Riverbraid-Memory-Gold', 'Riverbraid-Integration-Gold', 'Riverbraid-Harness-Gold']
def fatal(msg): print(f'FATAL:{msg}'); sys.exit(1)
cn, cm = None, None
print('STARTING GATE 5')
for r in REPOS:
    p = f'/workspaces/{r}/package.json'
    if not os.path.exists(p): continue
    raw = open(p, 'r').read()
    if raw.count('"engines"') > 1: fatal(f'DUP_ENGINES:{r}')
    d = json.loads(raw)
    e = d.get('engines', {})
    n, m = e.get('node'), e.get('npm')
    if not n or not m: fatal(f'MISSING_ENGINES:{r}')
    if cn is None: cn, cm = n, m
    if n != cn: fatal(f'NODE_DRIFT:{r}:{n}!={cn}')
    if m != cm: fatal(f'NPM_DRIFT:{r}:{m}!={cm}')
print('PASS:GATE 5')

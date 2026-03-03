#!/usr/bin/env python3
import sys, hashlib, json, logging, os
from pathlib import Path

ANCHOR_FILE = Path('.anchor')
PROTOCOL_FILE = Path('protocol.steps')
STATE_FILE = Path('logical_clock.state')

def compute_anchor(state):
    canonical = json.dumps(state, sort_keys=True, separators=(',', ':'))
    return hashlib.sha256(canonical.encode()).hexdigest()

def main():
    if not PROTOCOL_FILE.exists():
        print("DRIFT_DETECTED: Missing protocol.steps")
        sys.exit(1)
    with open(PROTOCOL_FILE, 'r') as f:
        protocol = f.read().strip()
    
    current_anchor = compute_anchor({"protocol": protocol})

    if not ANCHOR_FILE.exists():
        with open(ANCHOR_FILE, 'w') as f: f.write(current_anchor)
        if not STATE_FILE.exists():
            with open(STATE_FILE, 'w') as f: json.dump({'clock': 0}, f)
        print("[Signal: LOGICAL_CLOCK | Braid: CLOSED-LOOP]")
        sys.exit(0)

    with open(ANCHOR_FILE, 'r') as f:
        if current_anchor != f.read().strip():
            print("DRIFT_DETECTED")
            sys.exit(1)
    
    print("[Signal: LOGICAL_CLOCK | Braid: CLOSED-LOOP]")
    sys.exit(0)

if __name__ == "__main__":
    main()

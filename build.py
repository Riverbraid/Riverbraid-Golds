import json, hashlib, os
def get_petal_hash(petal_path):
    anchor_path = os.path.join(petal_path, '.anchor')
    if os.path.exists(anchor_path):
        with open(anchor_path, 'r') as f: return f.read().strip()
    return None
def compute_merkle_root(hashes):
    sorted_hashes = sorted([h for h in hashes if h])
    combined = "".join(sorted_hashes)
    return hashlib.sha256(combined.encode()).hexdigest()
def run_build():
    petals = [d for d in os.listdir('/workspaces') if d.startswith('Riverbraid') and os.path.isdir(os.path.join('/workspaces', d))]
    petal_hashes = []
    print("Collecting petal anchors...")
    for petal in petals:
        h = get_petal_hash(os.path.join('/workspaces', petal))
        if h: 
            print(f"  {petal}: {h}"); petal_hashes.append(h)
        else: 
            print(f"  {petal}: MISSING ANCHOR")
    merkle_root = compute_merkle_root(petal_hashes)
    print(f"\nFinal Cluster Merkle Root: {merkle_root}")
    output = {
        "status": "STATIONARY",
        "cluster_merkle_root": merkle_root,
        "petals": {petal: h for petal, h in zip(petals, petal_hashes)}
    }
    with open('vectors.json', 'w') as f: json.dump(output, f, indent=2)
if __name__ == '__main__': run_build()

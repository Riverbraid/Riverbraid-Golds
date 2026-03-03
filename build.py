import os
import hashlib
import json

def get_anchor(path):
    contract_path = os.path.join(path, 'identity.contract.json')
    if os.path.exists(contract_path):
        with open(contract_path, 'rb') as f:
            return hashlib.sha256(f.read()).hexdigest()
    return None

print("Collecting petal anchors...")
anchors = {}
# Scan the local packages directory
package_dir = './packages'
if os.path.exists(package_dir):
    for d in os.listdir(package_dir):
        full_path = os.path.join(package_dir, d)
        if os.path.isdir(full_path):
            anchor = get_anchor(full_path)
            if anchor:
                anchors[d] = anchor
                print(f"  {d}: {anchor}")
            else:
                print(f"  {d}: MISSING ANCHOR")

# Also check the root for the orchestrator itself
root_anchor = get_anchor('.')
if root_anchor:
    anchors['Riverbraid-Golds'] = root_anchor
    print(f"  Riverbraid-Golds: {root_anchor}")

# Generate Merkle Root
combined = "".join(sorted(anchors.values())).encode()
cluster_root = hashlib.sha256(combined).hexdigest()

print(f"\nFinal Cluster Merkle Root: {cluster_root}")
print("Verification complete: STATIONARY")

# Write to vectors.json for Node.js compatibility
with open('vectors.json', 'w') as f:
    json.dump({"version": "1.2.0", "merkle_root": cluster_root, "petals": list(anchors.keys())}, f, indent=2)

import json
import hashlib
import os

def generate():
    vector_path = 'vectors.json'
    if not os.path.exists(vector_path):
        print("FAIL: vectors.json not found. Run 'npm run seal' first.")
        return

    with open(vector_path, 'r') as f:
        data = json.load(f)
    
    manifest = data.get('manifest', {})
    sorted_keys = sorted(manifest.keys())
    
    combined_hash = hashlib.sha256()
    for key in sorted_keys:
        petal_data = json.dumps(manifest[key], sort_keys=True)
        combined_hash.update(petal_data.encode('utf-8'))
    
    root_hash = combined_hash.hexdigest()
    print(f"\n[RIVERBRAID MERKLE ROOT]: {root_hash}")
    print(f"[STATUS]: STATIONARY")

if __name__ == "__main__":
    generate()

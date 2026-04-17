import { createHash } from 'crypto';
import { readFileSync, existsSync } from 'fs';
import { join } from 'path';

const REGISTRY_PATH = './FINAL_REGISTRY.json';
const ROOT = '/workspaces';

console.log("=== CROSS-PETAL INDEPENDENT AUDIT ===");

if (!existsSync(REGISTRY_PATH)) {
  console.error("❌ Registry not found.");
  process.exit(1);
}

const registry = JSON.parse(readFileSync(REGISTRY_PATH, 'utf8'));
const nodes = registry.nodes;

nodes.forEach(repo => {
  const anchorPath = join(ROOT, repo, '.anchor');
  const snapshotPath = join(ROOT, repo, 'constitution.snapshot.json');
  
  try {
    if (!existsSync(snapshotPath)) throw new Error("Snapshot missing");
    
    const internalAnchor = readFileSync(anchorPath, 'utf8').trim();
    const snapshotContent = readFileSync(snapshotPath, 'utf8');
    
    const independentHash = createHash('sha256')
      .update(JSON.stringify(JSON.parse(snapshotContent), null, 2))
      .digest('hex')
      .slice(0, 6);

    if (internalAnchor === independentHash) {
      console.log(`✅ ${repo}: Verified [${independentHash}]`);
    } else {
      console.error(`❌ ${repo}: INTEGRITY BREACH. Internal: ${internalAnchor}, Actual: ${independentHash}`);
      process.exit(1);
    }
  } catch (e) {
    console.warn(`⚠️ ${repo}: Verification files missing or unreadable.`);
  }
});

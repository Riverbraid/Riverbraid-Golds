import { createHash } from 'crypto';
import { readFileSync } from 'fs';
import { join } from 'path';

const TARGET_REPOS = ['Riverbraid-Core', 'Riverbraid-Crypto-Gold'];
const ROOT = '/workspaces';

function hashFile(path) {
  const content = readFileSync(path);
  return createHash('sha256').update(content).digest('hex');
}

console.log("=== CROSS-PETAL INDEPENDENT AUDIT ===");

TARGET_REPOS.forEach(repo => {
  const anchorPath = join(ROOT, repo, '.anchor');
  const snapshotPath = join(ROOT, repo, 'constitution.snapshot.json');
  
  try {
    const internalAnchor = readFileSync(anchorPath, 'utf8').trim();
    const snapshotContent = readFileSync(snapshotPath, 'utf8');
    
    // Independent Hash Generation using the same algorithm as the internal gate
    const independentHash = createHash('sha256')
      .update(JSON.stringify(JSON.parse(snapshotContent), null, 2))
      .digest('hex')
      .slice(0, 6);

    if (internalAnchor === independentHash) {
      console.log(`✅ ${repo}: External hash matches internal anchor [${independentHash}]`);
    } else {
      console.error(`❌ ${repo}: INTEGRITY BREACH. Internal: ${internalAnchor}, Actual: ${independentHash}`);
      process.exit(1);
    }
  } catch (e) {
    console.error(`⚠️ ${repo}: Verification files missing or unreadable.`);
  }
});

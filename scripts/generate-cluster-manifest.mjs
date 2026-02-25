import fs from 'node:fs';
import path from 'node:path';

const WORKSPACE = "/workspaces";
const GOLDS_ROOT = "/workspaces/Riverbraid-Golds";
const REPOS = [
  'Riverbraid-Core',
  'Riverbraid-Golds',
  'Riverbraid-Crypto-Gold',
  'Riverbraid-Judicial-Gold'
];

const manifest = {
  generated: new Date().toISOString(),
  invariants: {},
  seals: {}
};

for (const repo of REPOS) {
  const repoPath = path.join(WORKSPACE, repo);
  const idPath = path.join(repoPath, 'identity.contract.json');
  if (fs.existsSync(idPath)) {
    manifest.invariants[repo] = JSON.parse(fs.readFileSync(idPath, 'utf8'));
  }
}

fs.writeFileSync(path.join(GOLDS_ROOT, 'GOLD_CLUSTER.manifest.json'), JSON.stringify(manifest, null, 2));
console.log('✅ GOLD_CLUSTER.manifest.json generated');

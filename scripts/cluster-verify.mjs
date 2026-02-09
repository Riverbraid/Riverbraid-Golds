import { execSync } from 'child_process';
import path from 'path';

const packages = [
  'core', 'crypto-gold', 'judicial-gold', 
  'memory-gold', 'safety-gold', 'refusal-gold', 'integration-gold'
];

console.log("--- RIVERBRAID GOLD: CLUSTER VERIFICATION ---");

packages.forEach(pkg => {
  try {
    const pkgPath = path.join(process.cwd(), 'packages', pkg);
    const output = execSync('node index.js', { cwd: pkgPath }).toString();
    console.log(`[PASS] ${pkg}: ${output.trim()}`);
  } catch (e) {
    console.log(`[FAIL] ${pkg}: Signal lost.`);
  }
});

const { execSync } = require('child_process');
const { existsSync } = require('fs');
const path = require('path');

const PETALS = [
  'Riverbraid-Core', 'Riverbraid-Cognition', 'Riverbraid-Crypto-Gold',
  'Riverbraid-Judicial-Gold', 'Riverbraid-Refusal-Gold', 'Riverbraid-Memory-Gold',
  'Riverbraid-Integration-Gold', 'Riverbraid-Harness-Gold', 'Riverbraid-Temporal-Gold'
];

const WORKSPACE = path.resolve(__dirname, '..');
let allPass = true;

for (const petal of PETALS) {
  const verifyPath = path.join(WORKSPACE, petal, 'verify.mjs');
  if (!existsSync(verifyPath)) {
    console.error(`  MISSING: ${petal}`);
    allPass = false;
    continue;
  }
  try {
    execSync(`node ${verifyPath}`, { stdio: 'inherit', cwd: path.join(WORKSPACE, petal) });
    console.log(`  PASS: ${petal}`);
  } catch (e) {
    allPass = false;
  }
}
process.exit(allPass ? 0 : 1);

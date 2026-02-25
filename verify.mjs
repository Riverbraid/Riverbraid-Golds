import fs from 'node:fs';
import path from 'node:path';

const fatal = (msg) => {
  console.error(`[FAIL-CLOSED] ${msg}`);
  process.exit(1);
};

try {
  const contract = JSON.parse(fs.readFileSync('./identity.contract.json', 'utf8'));
  console.log(`[VERIFY] Checking Judicial Petal: ${contract.name}`);

  for (const file of contract.governed_files) {
    if (!fs.existsSync(path.resolve(file))) fatal(`Governed file missing: ${file}`);
    console.log(`[OK] ${file} present.`);
  }

  // Judicial Specific: Check for entropy violations
  const grammar = fs.readFileSync('./grammar.pegjs', 'utf8');
  if (grammar.includes('Date.now()')) fatal('Entropy violation: Date.now() found in grammar.');

  console.log('[STATIONARY] Judicial Logic Verified.');
} catch (err) {
  fatal(`Structural failure: ${err.message}`);
}

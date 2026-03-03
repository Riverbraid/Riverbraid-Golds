#!/usr/bin/env node
const { execSync } = require('child_process');
const fs = require('fs');

console.log('Running Hygiene...');
try {
  execSync('python3 gate2_byte_audit.py', { stdio: 'inherit' });
} catch (error) {
  console.error('Byte audit failed');
  process.exit(1);
}

console.log('Running Entropy Scan...');
try {
  execSync('python3 gate3_entropy_scan.py', { stdio: 'inherit' });
} catch (error) {
  console.error('Entropy scan failed');
  process.exit(1);
}

console.log('Building Vectors...');
const vectors = {
  timestamp: new Date().toISOString(),
  version: '1.2.0',
  gates: { hygiene: 'PASS', entropy_scan: 'PASS' },
  petals: [
    'Riverbraid-Core', 'Riverbraid-Cognition', 'Riverbraid-Crypto-Gold',
    'Riverbraid-Judicial-Gold', 'Riverbraid-Refusal-Gold', 'Riverbraid-Memory-Gold',
    'Riverbraid-Integration-Gold', 'Riverbraid-Safety-Gold', 'Riverbraid-Harness-Gold',
    'Riverbraid-Temporal-Gold'
  ]
};
fs.writeFileSync('vectors.json', JSON.stringify(vectors, null, 2));
console.log('Vectors written to vectors.json');

#!/usr/bin/env node
const { execSync } = require('child_process');
const fs = require('fs');

const gateResults = { hygiene: 'FAIL', entropy: 'FAIL' };

console.log('Running Hygiene: Gate 2 Byte Audit...');
try {
  execSync('python3 gate2_byte_audit.py', { stdio: 'inherit' });
  gateResults.hygiene = 'PASS';
} catch {
  console.error('Gate 2 Failed.');
  process.exit(1);
}

console.log('Running Hygiene: Gate 3 Entropy Scan...');
try {
  execSync('python3 gate3_entropy_scan.py', { stdio: 'inherit' });
  gateResults.entropy = 'PASS';
} catch {
  console.error('Gate 3 Failed.');
  process.exit(1);
}

console.log('Building Vectors...');
const vectors = {
  version: '1.3.0',
  status: 'STATIONARY',
  gates: gateResults,
  petals: [
    'Riverbraid-Core',
    'Riverbraid-Cognition',
    'Riverbraid-Crypto-Gold',
    'Riverbraid-Judicial-Gold',
    'Riverbraid-Refusal-Gold',
    'Riverbraid-Memory-Gold',
    'Riverbraid-Integration-Gold',
    'Riverbraid-Harness-Gold',
    'Riverbraid-Temporal-Gold'
  ]
};

fs.writeFileSync('vectors.json', JSON.stringify(vectors, null, 2));
console.log('Absolute V2: vectors.json sealed.');

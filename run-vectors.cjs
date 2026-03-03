#!/usr/bin/env node
const { execSync } = require('child_process');
const fs = require('fs');
const gateResults = { hygiene: 'FAIL', entropy: 'FAIL' };

try {
  execSync('python3 gate2_byte_audit.py', { stdio: 'inherit' });
  gateResults.hygiene = 'PASS';
  execSync('python3 gate3_entropy_scan.py', { stdio: 'inherit' });
  gateResults.entropy = 'PASS';
} catch (e) {
  console.error('Gate Failure: Pipeline Halted.');
  process.exit(1);
}

const vectors = { version: '1.3.0', status: 'STATIONARY', gates: gateResults };
fs.writeFileSync('vectors.json', JSON.stringify(vectors, null, 2));
console.log('Absolute V2: vectors.json sealed.');

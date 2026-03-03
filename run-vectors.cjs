#!/usr/bin/env node
const { execSync } = require('child_process');
const fs = require('fs');

console.log('🧹 Running Hygiene: Gate Audit...');
try {
  execSync('python3 gate2_byte_audit.py', { stdio: 'inherit' });
  execSync('python3 gate3_entropy_scan.py', { stdio: 'inherit' });
} catch (error) {
  console.error('❌ Hygiene Failed');
  process.exit(1);
}

console.log('🏗 Building Vectors: Deterministic Assembly...');
const vectors = {
  version: '1.2.0',
  status: 'STATIONARY',
  gates: { hygiene: 'PASS', entropy: 'PASS' },
  petals: [
    'Riverbraid-Core', 'Riverbraid-Cognition', 'Riverbraid-Crypto-Gold',
    'Riverbraid-Judicial-Gold', 'Riverbraid-Refusal-Gold', 'Riverbraid-Memory-Gold',
    'Riverbraid-Integration-Gold', 'Riverbraid-Safety-Gold', 'Riverbraid-Harness-Gold',
    'Riverbraid-Temporal-Gold'
  ]
};

fs.writeFileSync('vectors.json', JSON.stringify(vectors, null, 2));
console.log('✅ Absolute V2: vectors.json sealed.');

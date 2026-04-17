#!/usr/bin/env node
'use strict';

const fs = require('fs');
const crypto = require('crypto');

const MANIFEST = 'golds.manifest.json';

function sha256Hex(buf) {
  return crypto.createHash('sha256').update(buf).digest('hex');
}

function fail(msg) {
  console.error(msg);
  process.exit(1);
}

function main() {
  const cmd = process.argv[2];
  if (cmd !== 'verify') fail('Usage: node run-vectors.cjs verify');

  if (process.version !== 'v24.11.1') {
    fail(`NODE_VERSION_MISMATCH: expected v24.11.1 but found ${process.version}`);
  }

  if (!fs.existsSync(MANIFEST)) fail(`MISSING_REQUIRED_FILE: ${MANIFEST}`);

  const raw = fs.readFileSync(MANIFEST);
  const text = raw.toString('utf8');

  if (text.includes('\r')) fail(`CRLF_FORBIDDEN: ${MANIFEST}`);
  if (!text.endsWith('\n')) fail(`MISSING_TRAILING_LF: ${MANIFEST}`);

  let manifest;
  try {
    manifest = JSON.parse(text);
  } catch {
    fail(`INVALID_JSON: ${MANIFEST}`);
  }

  if (manifest.version !== '1.5.0') {
    fail(`VERSION_MISMATCH: expected 1.5.0 but found ${manifest.version}`);
  }

  if (!Array.isArray(manifest.repositories) || manifest.repositories.length === 0) {
    fail('INVALID_MANIFEST: repositories must be a non empty array');
  }

  const seen = new Set();
  for (const repo of manifest.repositories) {
    if (!repo || typeof repo !== 'object') fail('INVALID_MANIFEST_ENTRY');
    if (typeof repo.name !== 'string' || repo.name.length === 0) fail('INVALID_REPOSITORY_NAME');
    if (typeof repo.role !== 'string' || repo.role.length === 0) fail(`INVALID_REPOSITORY_ROLE: ${repo.name}`);
    if (seen.has(repo.name)) fail(`DUPLICATE_REPOSITORY: ${repo.name}`);
    seen.add(repo.name);
  }

  console.log('VERIFIED: Gold registry manifest is coherent.');
  console.log(`SHA256: ${sha256Hex(raw)}`);
}

main();


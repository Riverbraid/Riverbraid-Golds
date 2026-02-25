import fs from 'fs';
import { computeRoot } from '/workspaces/Riverbraid-Core/src/merkle.mjs';
import { anchor } from '/workspaces/Riverbraid-Crypto-Gold/src/anchor.mjs';

const stateMap = JSON.parse(fs.readFileSync('/workspaces/Riverbraid-Memory-Gold/state.map.json', 'utf8'));
const leaves = Object.keys(stateMap).sort().map(key => anchor(`${key}:${stateMap[key]}`));
const root = computeRoot(leaves);

console.log(`MERKLE_ROOT:${root}`);

// STATIONARY INVARIANT CHECK
const EXPECTED_ROOT = "de20624134f82d304d694432c31648a2963617df5b241e9496a71e0fecf40ece"; 
  console.error("FATAL: Merkle Root Mismatch.");
  process.exit(1);
}

import fs from 'node:fs';

// Placeholder for @riverbraid/core functions until package is linked
const enforceAscii = (str) => str.replace(/[^\x00-\x7F]/g, "");
const failClosedGate = (bool) => bool === true;

const VECTORS = JSON.parse(fs.readFileSync('./vectors/intent_map.json', 'utf8'));

export function translateIntent(input) {
  const sanitized = enforceAscii(input).toLowerCase();
  const match = VECTORS.vectors.find(v => v.intent === sanitized);
  
  if (!match) {
    return { authorized: false, error: "SIGNAL_DISTORTION" };
  }
  
  return {
    authorized: failClosedGate(true),
    symbols: match.symbols,
    executable: match.action
  };
}

import { translateIntent } from '../src/state.js';
import assert from 'node:assert';

console.log("LOG: Starting Semantic Bridge Operational Test...");

// Test 1: Valid Intent Mapping
const validResult = translateIntent("start_verification");
assert.strictEqual(validResult.authorized, true, "Valid intent should be authorized");
assert.ok(validResult.symbols.includes("INIT"), "Symbols should include INIT");
console.log("PASS: Valid Intent Mapping");

// Test 2: Entropy Rejection (Sanitization)
// Input with non-ASCII or uppercase should be handled by the bridge
const noisyResult = translateIntent("START_VERIFICATION");
assert.strictEqual(noisyResult.authorized, true, "Bridge should handle case-insensitivity");
console.log("PASS: Noise Sanitization");

// Test 3: Fail-Closed on Unknown Intent
const invalidResult = translateIntent("unauthorized_access_attempt");
assert.strictEqual(invalidResult.authorized, false, "Unknown intent must fail-closed");
assert.strictEqual(invalidResult.error, "SIGNAL_DISTORTION", "Error code must match spec");
console.log("PASS: Fail-Closed Logic");

console.log("LOG: All Bridge Tests Passed.");

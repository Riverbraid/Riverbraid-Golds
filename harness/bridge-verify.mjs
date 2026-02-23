import fs from 'node:fs';
console.log('--- HARNESS: BRIDGE VERIFICATION ---');
// Test: Can we read the Judicial rules from the harness?
try {
    const rules = fs.readFileSync('../packages/judicial-gold/policy.rules', 'utf8');
    console.log('OK: Judicial rules reachable.');
    if (rules.includes('DENY .*')) {
        console.log('OK: Fail-Closed invariant detected.');
    } else {
        throw new Error('FAIL: Invariant missing in runtime!');
    }
} catch (e) {
    console.error('FATAL: Bridge broken - ' + e.message);
    process.exit(1);
}
console.log('--- RESULT: INTEGRATION SUCCESSFUL ---');

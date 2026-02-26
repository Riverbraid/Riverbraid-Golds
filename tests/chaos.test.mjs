import { pulse } from './heartbeat.mjs';

const mockMetrics = {
  mode: 'rest',
  coherence: 1.0,
  novelty: 0.0,
  systemic_load: 0.05,
  pattern_disruption: 0.0,
  interaction_variance: 0.0,
  AUDIT_HASH: 'de2062' // Matches your Merkle Root
};

console.log("--- FINAL ALIGNMENT TEST: RIVERBRAID GOLD ---");
try {
  // Testing P5: Determinism by passing the audit hash as both current and prior
  const result = pulse(mockMetrics, 'de2062');
  
  if (result.all_passed) {
    console.log("✅ STATIONARY STATE CONFIRMED");
    console.log("✅ SIGNAL: " + result.signal);
    console.log("✅ HEARTBEAT HASH: " + result.HEARTBEAT_HASH);
    console.log("\n--- THE BRAID IS SEATED ---");
  } else {
    console.error("❌ FAIL-CLOSED: INVARIANT VIOLATION DETECTED");
    process.exit(1);
  }
} catch (e) {
  console.error("❌ SYSTEM DISRUPTION: " + e.message);
  process.exit(1);
}

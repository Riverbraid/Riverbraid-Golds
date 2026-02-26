import { pulse } from './heartbeat.mjs';

const mockMetrics = {
  mode: 'rest',
  coherence: 1.0,
  novelty: 0.0,
  systemic_load: 0.1,
  pattern_disruption: 0.0,
  interaction_variance: 0.01, // Provides the buffer for P3
  coherence_confidence: 0.8,   // Satisfies P6
  AUDIT_HASH: 'de2062'        // Your Merkle Root
};

console.log("--- FINAL ALIGNMENT TEST: RIVERBRAID GOLD ---");
try {
  // We pass 'de2062' as the prior to satisfy P5: Determinism
  const result = pulse(mockMetrics, 'de2062');
  
  if (result.all_passed) {
    console.log("✅ STATIONARY STATE CONFIRMED");
    console.log("✅ SIGNAL: " + result.signal);
    console.log("✅ HEARTBEAT HASH: " + result.HEARTBEAT_HASH);
    console.log("\n--- THE BRAID IS SEATED ---");
  } else {
    console.error("❌ FAIL-CLOSED: INVARIANT VIOLATION DETECTED");
    // Explicitly log the metrics so we see which prediction tripped
    process.exit(1);
  }
} catch (e) {
  console.error("❌ SYSTEM DISRUPTION: " + e.message);
  process.exit(1);
}

import { pulse } from './heartbeat.mjs';

const mockMetrics = {
  mode: 'engage',
  coherence: 0.9,
  novelty: 0.2,
  systemic_load: 0.1,
  pattern_disruption: 0.0001,
  interaction_variance: 0.05,
  AUDIT_HASH: 'de2062'
};

console.log("--- STARTING CHAOS TEST: RIVERBRAID GOLD ---");
try {
  const result = pulse(mockMetrics);
  if (result.all_passed) {
    console.log("✅ STATIONARY STATE CONFIRMED: HASH " + result.HEARTBEAT_HASH);
  } else {
    console.error("❌ FAIL-CLOSED TRIGGERED");
    process.exit(1);
  }
} catch (e) {
  console.error("❌ SYSTEM DISRUPTION: " + e.message);
  process.exit(1);
}

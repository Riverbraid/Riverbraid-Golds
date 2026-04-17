const fs = require('fs');
const crypto = require('crypto');

const PULSE_DIR = '/workspaces/Riverbraid-Temporal-Gold';
const pulses = fs.readdirSync(PULSE_DIR).filter(f => f.startsWith('swarm.pulse') && f.endsWith('.json'));

console.log(`[AUDIT] Scanning ${pulses.length} temporal pulses...`);

const seenSequences = new Set();
const seenTimestamps = new Set();
let duplicatesFound = 0;

pulses.forEach(file => {
    const data = JSON.parse(fs.readFileSync(`${PULSE_DIR}/${file}`, 'utf8'));
    
    if (seenSequences.has(data.sequence) || seenTimestamps.has(data.iso_8601)) {
        console.error(`[COLLISION] Duplicate detected in ${file}: Seq ${data.sequence} / Time ${data.iso_8601}`);
        duplicatesFound++;
    }

    seenSequences.add(data.sequence);
    seenTimestamps.add(data.iso_8601);
});

if (duplicatesFound === 0) {
    console.log(`[CLEAN] Temporal Integrity Verified. No duplicate pulses found.`);
} else {
    console.error(`[CRITICAL] ${duplicatesFound} temporal collisions detected. System Drift Active.`);
    process.exit(1);
}

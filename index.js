// Sovereign Reference Index – Riverbraid-Golds v1.2.0
const { execSync } = require('child_process');
const fs = require('fs');

function runPipeline() {
  console.log('Running Absolute V2 pipeline...');
  execSync('python3 build.py', { stdio: 'inherit' });
}

function getClusterStatus() {
  if (fs.existsSync('vectors.json')) {
    try {
      return JSON.parse(fs.readFileSync('vectors.json', 'utf8'));
    } catch (e) {
      return { status: 'ERROR', message: 'Failed to parse vectors.json' };
    }
  }
  return { status: 'UNKNOWN', message: 'vectors.json not found' };
}

function runVectors() {
  require('./run-vectors.cjs');
}

module.exports = { runPipeline, getClusterStatus, runVectors };
if (require.main === module) { runPipeline(); }

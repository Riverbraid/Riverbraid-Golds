const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

function runPipeline() {
  execSync('node run-vectors.cjs', { stdio: 'inherit', cwd: __dirname });
}

function getStatus() {
  const vectorsPath = path.join(__dirname, 'vectors.json');
  if (fs.existsSync(vectorsPath)) {
    try { return JSON.parse(fs.readFileSync(vectorsPath, 'utf8')); }
    catch { return { status: 'CORRUPT' }; }
  }
  return { status: 'UNKNOWN', reason: 'pipeline has not run' };
}

module.exports = { runPipeline, getStatus };

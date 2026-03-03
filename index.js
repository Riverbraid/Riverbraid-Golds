const { execSync } = require('child_process');
const fs = require('fs');
function runPipeline() {
  console.log('Running Absolute V2 pipeline...');
  execSync('python3 build.py', { stdio: 'inherit' });
}
function getClusterStatus() {
  if (fs.existsSync('vectors.json')) return JSON.parse(fs.readFileSync('vectors.json', 'utf8'));
  return { status: 'UNKNOWN' };
}
module.exports = { runPipeline, getClusterStatus };
if (require.main === module) runPipeline();

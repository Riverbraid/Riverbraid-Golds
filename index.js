const { execSync } = require('child_process');
const fs = require('fs');

function runPipeline() {
  execSync('python3 build.py', { stdio: 'inherit' });
}

function getStatus() {
  return fs.existsSync('vectors.json') 
    ? JSON.parse(fs.readFileSync('vectors.json', 'utf8'))
    : { status: 'UNKNOWN' };
}

module.exports = { runPipeline, getStatus };

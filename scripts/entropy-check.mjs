import fs from 'node:fs';
import path from 'node:path';

const isAscii = (str) => /^[\x00-\x7F]*$/.test(str);

const checkFile = (filePath) => {
  const content = fs.readFileSync(filePath, 'utf8');
  if (!isAscii(content)) {
    console.error(`ENTROPY_VIOLATION: Non-ASCII characters detected in ${filePath}`);
    process.exit(1);
  }
};

console.log("LOG: Running Entropy Scan (ASCII Floor)...");
// Basic scan of src directory
const files = fs.readdirSync('./src');
files.forEach(file => checkFile(path.join('./src', file)));
console.log("LOG: Scan Complete. Coherence Maintained.");

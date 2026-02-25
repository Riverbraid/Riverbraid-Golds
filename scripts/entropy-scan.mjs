import fs from 'fs';
import path from 'path';


const scanDir = (dir) => {
  if (!fs.existsSync(dir)) return;
  const files = fs.readdirSync(dir);
  files.forEach(file => {
    const fullPath = path.join(dir, file);
    if (fs.lstatSync(fullPath).isDirectory() && !fullPath.includes('node_modules')) {
      scanDir(fullPath);
    } else if (fullPath.endsWith('.js') || fullPath.endsWith('.ts') || fullPath.endsWith('.mjs')) {
      const content = fs.readFileSync(fullPath, 'utf8');
      BANNED.forEach(regex => {
        if (regex.test(content)) {
          console.error(` Entropy violation in ${fullPath}: ${regex}`);
          process.exit(1);
        }
      });
    }
  });
};

console.log(" Scanning for non-deterministic entropy...");
scanDir('./packages');
console.log(" No forbidden entropy detected.");

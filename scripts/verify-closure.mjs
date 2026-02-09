import fs from "node:fs";
import path from "node:path";

const packagesDir = path.resolve("packages");

if (!fs.existsSync(packagesDir)) {
  console.error("FAIL: packages/ missing. Run: npm run setup");
  process.exit(1);
}

const cells = fs.readdirSync(packagesDir, { withFileTypes: true })
  .filter(d => d.isDirectory())
  .map(d => d.name);

if (cells.length === 0) {
  console.error("FAIL: packages/ is empty. Submodules not wired.");
  process.exit(1);
}

for (const cell of cells) {
  const pkgPath = path.join(packagesDir, cell, "package.json");
  const entryPath = path.join(packagesDir, cell, "index.js");

  if (!fs.existsSync(pkgPath)) {
    console.error(`FAIL: ${cell} missing package.json`);
    process.exit(1);
  }
  if (!fs.existsSync(entryPath)) {
    console.error(`FAIL: ${cell} missing index.js`);
    process.exit(1);
  }
}

console.log("SUCCESS: All Gold cells are manifest and closed.");

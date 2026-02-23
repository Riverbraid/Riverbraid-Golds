import fs from "node:fs";
import path from "node:path";

const packagesDir = path.resolve("packages");

if (!fs.existsSync(packagesDir)) {
  console.error("FAIL: packages/ missing.");
  process.exit(1);
}

const cells = fs.readdirSync(packagesDir, { withFileTypes: true })
  .filter(d => d.isDirectory())
  .map(d => d.name);

console.log(`[CHECK] Found ${cells.length} cells in packages/`);

let ok = true;
for (const cell of cells) {
  const pkgPath = path.join(packagesDir, cell, "package.json");
  if (fs.existsSync(pkgPath)) {
    console.log(` ${cell}: package.json found.`);
  } else {
    console.error(` ${cell}: package.json MISSING at ${pkgPath}`);
    ok = false;
  }
}

if (!ok || cells.length === 0) {
  process.exit(1);
}

console.log("\nSUCCESS: All Gold cells contain package.json closures.");

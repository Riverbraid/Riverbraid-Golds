import fs from "node:fs";
import path from "node:path";
import { execSync } from "node:child_process";

const packagesDir = path.resolve("packages");
const cells = fs.readdirSync(packagesDir).filter(d => 
  fs.statSync(path.join(packagesDir, d)).isDirectory()
);

console.log("🚀 Running Gold Test Vectors...");

let totalPassed = 0;

for (const cell of cells) {
  const cellPath = path.join(packagesDir, cell);
  const vectorFile = path.join(cellPath, "index.js");

  if (fs.existsSync(vectorFile)) {
    try {
      const output = execSync(`node ${vectorFile}`, { encoding: "utf8" });
      const data = JSON.parse(output);
      if (data.status === "STATIONARY") {
        console.log(`✅ ${cell}: Vector Validated (${data.repo})`);
        totalPassed++;
      }
    } catch (e) {
      console.error(`❌ ${cell}: Vector Corrupted or Failed`);
      process.exit(1);
    }
  }
}

console.log(`\nSUCCESS: ${totalPassed}/${cells.length} Vectors are Stationary.`);

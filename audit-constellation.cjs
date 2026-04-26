const fs = require("fs");
const path = require("path");
const { execSync } = require("child_process");

const home = process.env.USERPROFILE || process.env.HOME;
const root = path.join(home, "riverbraid");
const repos = fs.readdirSync(root).filter(f => f.toLowerCase().includes("riverbraid")).sort();

console.log("\n--- RIVERBRAID CONSTELLATION: FUNCTIONAL FLOOR AUDIT ---");
let total = 0;
let passed = 0;

repos.forEach(repo => {
  const p = path.join(root, repo);
  const pkgPath = path.join(p, "package.json");
  if (repo.toLowerCase() === 'riverbraid-golds') return;
  total++;
  
  if (fs.existsSync(pkgPath)) {
    try {
      execSync("npm test", { cwd: p, stdio: "inherit" });
      console.log(`? [PASS] ${repo.padEnd(30)} (Functional)`);
      passed++;
    } catch (e) {
      console.log(`? [FAIL] ${repo.padEnd(30)} (Test Error)`);
    }
  } else {
    console.log(`? [SKIP] ${repo.padEnd(30)} (No Manifest)`);
  }
});

console.log(`\nAudit Complete: ${passed}/${total} nodes verified functional.\n`);

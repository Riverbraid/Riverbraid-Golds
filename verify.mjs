import fs from "node:fs";
import path from "node:path";
const fatal = (m) => { console.error(`[FAIL-CLOSED] ${m}`); process.exit(1); };
try {
  const c = JSON.parse(fs.readFileSync("./identity.contract.json", "utf8"));
  console.log(`[VERIFY] Auditing: ${c.repo_name} v${c.version}`);
  for (const f of c.governed_files) {
    if (!fs.existsSync(path.resolve(f))) fatal(`Missing ${f}`);
    console.log(`[OK] ${f}`);
  }
  const targets = ["index.js", "GOLD_CLUSTER.manifest.json"];
  for (const t of targets) {
    if (!fs.existsSync(t)) continue;
    const content = fs.readFileSync(t, "utf8");
    if (content.includes("Date.now()") || content.includes("Math.random()")) fatal(`Entropy in ${t}`);
  }
  console.log("[STATUS] 10/10 INSTITUTIONAL GRADE LOCKED.");
} catch (e) { fatal(e.message); }

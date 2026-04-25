import fs from "fs";
import path from "path";
const ROOT = process.cwd();
const PETALS = ["Core", "Integration-Gold", "Crypto-Gold", "Judicial-Gold", "Safety-Gold", "Memory-Gold", "Action-Gold", "Temporal-Gold", "Vision-Gold", "Audio-Gold", "Harness-Gold", "Refusal-Gold", "Cognition", "Lang", "Interface-Gold"];
async function run() {
  console.log("🔗 Riverbraid Coupling Test\n");
  let ok = true;
  PETALS.forEach(p => {
    const d = path.join(ROOT, "../Riverbraid-" + p);
    const ex = fs.existsSync(d);
    console.log((ex ? "✅" : "❌") + " " + p);
    if(!ex) ok = false;
  });
  process.exit(ok ? 0 : 1);
}
run();

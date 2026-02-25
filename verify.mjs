import fs from "node:fs";
import path from "node:path";

const fatal = (msg) => { console.error(`VERIFY FAILED: ${msg}`); process.exit(1); };
const readJSON = (p) => JSON.parse(fs.readFileSync(p, "utf8"));

const root = process.cwd();
const contractPath = path.join(root, "identity.contract.json");
if (!fs.existsSync(contractPath)) fatal("Missing identity.contract.json");
const contract = readJSON(contractPath);

const forbidden = ["Date.now", "Math.random", "randomUUID", "new Date(", "performance.now", "process.env"];

for (const rel of contract.governed_files) {
  const full = path.join(root, rel);
  if (!fs.existsSync(full)) fatal(`Missing governed file: ${rel}`);
  if (rel.endsWith(".js") || rel.endsWith(".mjs") || rel.endsWith(".json")) {
    const content = fs.readFileSync(full, "utf8");
    for (const tok of forbidden) {
      if (content.includes(tok)) fatal(`Forbidden token in ${rel}: ${tok}`);
    }
  }
}
console.log("STATUS: INSTITUTIONAL GRADE LOCKED");

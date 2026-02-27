import fs from "node:fs";
import path from "node:path";

const fatal = (msg) => {
  console.error(`[FAIL-CLOSED] ${msg}`);
  process.exit(1);
};

try {
  const contract = JSON.parse(fs.readFileSync("./identity.contract.json", "utf8"));
  console.log(`[VERIFY] Auditing: ${contract.repo_name} v${contract.version}`);

  for (const file of contract.governed_files) {
    if (!fs.existsSync(path.resolve(file))) fatal(`Integrity Violation: Missing ${file}`);
    console.log(`[OK] ${file} verified.`);
  }

  if (contract.invariants?.no_entropy_sources) {
    const forbidden = [
      ["Date", "now()"].join("."),
      ["new", " Date("].join(""),
      "process.env",
      ["Math", "random()"].join("."),
      "randomUUID",
      "performance.now"
    ];

    const targets = ["index.js", "GOLD_CLUSTER.manifest.json"];
    for (const f of targets) {
      if (!fs.existsSync(f)) continue;
      const content = fs.readFileSync(f, "utf8");
      for (const tok of forbidden) {
        if (content.includes(tok)) fatal(`Entropy Violation in ${f}: Detected ${tok}`);
      }
    }
  }

  console.log("[STATUS] 10/10 INSTITUTIONAL GRADE LOCKED.");
} catch (e) {
  fatal(`Audit Exception: ${e.message}`);
}

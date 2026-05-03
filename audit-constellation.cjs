"use strict";
const fs = require("node:fs");
const path = require("node:path");
const { execSync } = require("node:child_process");

const workspace = path.resolve(__dirname, "..");
const manifestPath = path.join(workspace, "Riverbraid-Manifest-Gold", "riverbraid.constellation.json");

function readJson(file) {
  let raw = fs.readFileSync(file, "utf8");
  raw = raw
    .replace(/^\uFEFF/, "")
    .replace(/^\uFFFD+/, "")
    .trim();
  const firstObject = raw.indexOf("{");
  const firstArray = raw.indexOf("[");
  let start = -1;
  if (firstObject >= 0 && firstArray >= 0) {
    start = Math.min(firstObject, firstArray);
  } else {
    start = Math.max(firstObject, firstArray);
  }
  if (start < 0) {
    throw new Error("No JSON start found in " + file);
  }
  return JSON.parse(raw.slice(start));
}

const manifest = readJson(manifestPath);
const floor = manifest.canonical_floor || [];

console.log("--- RIVERBRAID CONSTELLATION AUDIT ---");
console.log("Target Floor Count:", floor.length);

const results = floor.map((repo) => {
  if (repo === "Riverbraid-Golds") {
    return {
      repo,
      state: "active",
      status: "SKIPPED_SELF",
      claim_boundary: "root-audit-self-recursion-blocked"
    };
  }

  const repoPath = path.join(workspace, repo);
  const packagePath = path.join(repoPath, "package.json");

  if (!fs.existsSync(repoPath)) {
    return {
      repo,
      state: "unknown",
      status: "FAIL_MISSING",
      failure_codes: ["RB_REPO_FOLDER_MISSING"]
    };
  }

  if (!fs.existsSync(packagePath)) {
    return {
      repo,
      state: "unknown",
      status: "FAIL_MISSING_PACKAGE",
      failure_codes: ["RB_PACKAGE_JSON_MISSING"]
    };
  }

  try {
    const output = execSync("npm run test:riverbraid --silent", {
      cwd: repoPath,
      encoding: "utf8",
      stdio: ["ignore", "pipe", "pipe"]
    }).trim();

    const firstBrace = output.indexOf("{");
    if (firstBrace < 0) {
      return {
        repo,
        state: "unknown",
        status: "FAIL_INVALID_OUTPUT",
        failure_codes: ["RB_VERIFIER_JSON_MISSING"],
        output
      };
    }
    return JSON.parse(output.slice(firstBrace));
  } catch (error) {
    return {
      repo,
      state: "unknown",
      status: "FAIL_ERROR",
      failure_codes: ["RB_VERIFIER_FAILED"],
      error: error.message
    };
  }
});

console.table(results);

const allowedNonFail = new Set(["PASS", "SKIPPED_SELF", "SKIPPED_DECLARED", "PARKED"]);
const failures = results.filter((r) => !allowedNonFail.has(r.status));

if (failures.length > 0) {
  console.error("AUDIT FAILED:", failures.length, "nodes non-compliant.");
  console.log(JSON.stringify({
    repo: "Riverbraid-Golds",
    status: "FAIL",
    result: "ROOT_AUDIT_FAILED",
    claim_boundary: "declared-conditions-only",
    failures
  }, null, 2));
  process.exit(1);
}

console.log(JSON.stringify({
  repo: "Riverbraid-Golds",
  status: "PASS",
  result: "ROOT_AUDIT_VERIFIED",
  claim_boundary: "declared-conditions-only",
  canonical_floor_count: floor.length,
  failures: []
}, null, 2));
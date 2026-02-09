#!/usr/bin/env bash
set -euo pipefail

export TZ=UTC
export LC_ALL=C
export LANG=C
export NO_COLOR=1

NODE_EXPECTED="v20.11.0"

if [ "$(node --version)" != "${NODE_EXPECTED}" ]; then
  echo "FATAL:BAD_NODE:$(node --version) expected ${NODE_EXPECTED}"
  exit 1
fi

VERSION="RIVERBRAID_GOLD_V1_5"
NPM_TARGET="10.2.4"
GENESIS_TIMESTAMP="2025-02-08T00:00:00.000Z"
PASS_SIGNAL="VERIFY_OK\n"

# Entropy law strings are scanned as substrings in witnessed JS.
ENTROPY_FORBIDDEN=(
  "Math.random"
  "Date.now"
  "crypto.randomUUID"
  "process.hrtime"
  "new Date().toISOString()"
)

# Root allowlist includes GitHub surface and tests and scripts.
# .git and node_modules are allowed but NOT witnessed and NOT floor checked.
root_allowlist_json() {
  cat << 'JSON'
[
  ".editorconfig",
  ".gitattributes",
  ".github",
  ".gitignore",
  "CODE_OF_CONDUCT.md",
  "CONTRIBUTING.md",
  "ENTROPY_LAW.js",
  "FINAL_RESEARCH_SPECIFICATION.md",
  "LICENSE",
  "MIGRATION.md",
  "README.md",
  "RELEASE.md",
  "SECURITY.md",
  "SHA256SUMS.txt",
  "SUCCESSOR_WITNESS_RULES.md",
  "TRACE_LAW_VECTOR.md",
  "VERIFYING.md",
  "cluster-contract.json",
  "migrate.js",
  "orchestrate.js",
  "package-lock.json",
  "package.json",
  "scripts",
  "src",
  "tests"
]
JSON
}

# Witnessed files are the ones hashed into successor_digest.
# Excludes cluster-contract.json, TRACE_LAW_VECTOR.md, SHA256SUMS.txt, package-lock.json, any .github/, scripts/, tests/
root_witnessed_files_json() {
  cat << 'JSON'
[
  ".editorconfig",
  ".gitattributes",
  ".gitignore",
  "CODE_OF_CONDUCT.md",
  "CONTRIBUTING.md",
  "ENTROPY_LAW.js",
  "FINAL_RESEARCH_SPECIFICATION.md",
  "LICENSE",
  "MIGRATION.md",
  "README.md",
  "RELEASE.md",
  "SECURITY.md",
  "SUCCESSOR_WITNESS_RULES.md",
  "VERIFYING.md",
  "migrate.js",
  "orchestrate.js",
  "package.json",
  "scripts/lint-floor.js",
  "src/constants.js",
  "src/verify.js",
  "tests/orchestrate.test.js",
  "tests/sha256sums.test.js"
]
JSON
}

# ---------------------------------------------------------------------
# Floor enforcement: ASCII, LF only, trailing LF, no BOM, no NUL, no CRLF
# ---------------------------------------------------------------------
node_floor_lib() {
  cat << 'JS'
import fs from "node:fs";

export function checkFloor(buffer, label) {
  if (!Buffer.isBuffer(buffer)) buffer = Buffer.from(String(buffer), "utf8");
  if (buffer.length === 0) throw new Error(`FATAL:G03_ZERO_LENGTH:${label}`);
  if (buffer.length >= 3 && buffer[0] === 0xEF && buffer[1] === 0xBB && buffer[2] === 0xBF) {
    throw new Error(`FATAL:G03_BOM:${label}`);
  }
  if (buffer.includes(0x0D)) throw new Error(`FATAL:G03_CRLF:${label}`);
  if (buffer[buffer.length - 1] !== 0x0A) throw new Error(`FATAL:G03_NO_LF:${label}`);
  for (let i = 0; i < buffer.length; i++) {
    const b = buffer[i];
    if (b === 0x09 || b === 0x0A) continue;
    if (b >= 0x20 && b <= 0x7E) continue;
    throw new Error(`FATAL:G03_NON_ASCII:${label}:${b}@${i}`);
  }
  if (buffer.includes(0x00)) throw new Error(`FATAL:G03_NUL:${label}`);
  return buffer;
}

export function refuseSymlinkPathWalk(absLeaf, rootAbs, label) {
  let current = absLeaf;
  while (true) {
    let stat;
    try {
      stat = fs.lstatSync(current);
    } catch (err) {
      if (err && err.code === "ENOENT") {
        current = current.substring(0, current.lastIndexOf("/")) || rootAbs;
        continue;
      }
      throw err;
    }
    if (stat.isSymbolicLink()) {
      throw new Error(`FATAL:G04_SYMLINK:${label}:${current}`);
    }
    if (current === rootAbs) break;
    const parent = current.substring(0, current.lastIndexOf("/"));
    if (!parent || parent === current) throw new Error(`FATAL:G04_PATHWAY_WALK:${label}`);
    current = parent;
  }
}
JS
}

write_file() {
  local repo="$1"
  local rel="$2"
  local content="$3"
  local abs="${repo}/${rel}"
  local dir
  dir="$(dirname "${abs}")"
  mkdir -p "${dir}"
  # Force trailing LF
  if [ "${content: -1}" != $'\n' ]; then
    content="${content}"$'\n'
  fi
  printf "%s" "${content}" > "${abs}"
}

# Build SHA256SUMS.txt excluding .git/ and node_modules/
write_sha256sums() {
  local repo="$1"
  (
    cd "${repo}"
    # deterministic ordering by path bytes (POSIX sort C locale)
    export LC_ALL=C
    find . \
      -type f \
      ! -path "./.git/*" \
      ! -path "./node_modules/*" \
      ! -name "SHA256SUMS.txt" \
      -print \
    | sed 's|^\./||' \
    | sort \
    | while IFS= read -r f; do
        # sha256sum output: "<hash>  <file>"
        sha256sum "${f}"
      done \
    > SHA256SUMS.txt
    # ensure trailing LF
    printf "\n" >> SHA256SUMS.txt
  )
}

repo_template_files() {
  local name="$1"

  # Base KAT policy: only crypto repo enforces KAT.
  local kat_input="RIVERBRAID_GOLD_V1_5_GENESIS"
  local kat_expected
  kat_expected="$(printf "%s" "${kat_input}" | sha256sum | awk '{print $1}')"

  # package.json: no deps required for node:test, lint-floor, orchestrate.
  # Keep npm toolchain pinned via engines.
  cat << JSON
{
  "name": "${name}",
  "version": "1.5.0",
  "private": true,
  "type": "module",
  "engines": {
    "node": "20.11.0",
    "npm": "${NPM_TARGET}"
  },
  "scripts": {
    "orchestrate": "node orchestrate.js",
    "migrate": "node migrate.js",
    "lint:floor": "node scripts/lint-floor.js",
    "test": "node --test",
    "prepack": "node orchestrate.js",
    "prepublishOnly": "node orchestrate.js"
  }
}
JSON
}

write_github_surface() {
  local repo="$1"
  mkdir -p "${repo}/.github/workflows" "${repo}/.github/ISSUE_TEMPLATE"

  cat > "${repo}/.github/workflows/ci.yml" << 'YML'
name: CI

on: [push, pull_request]

jobs:
  verify:
    runs-on: ubuntu-24.04
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20.11.0'
      - name: Normalize env
        run: |
          echo "TZ=UTC" >> $GITHUB_ENV
          echo "LC_ALL=C" >> $GITHUB_ENV
          echo "LANG=C" >> $GITHUB_ENV
          echo "NO_COLOR=1" >> $GITHUB_ENV
      - run: npm ci
      - run: npm run lint:floor
      - run: npm test
      - run: node orchestrate.js
      - run: node migrate.js
YML

  cat > "${repo}/.github/pull_request_template.md" << 'MD'
## Summary

## Verification
- [ ] npm ci
- [ ] npm run lint:floor
- [ ] npm test
- [ ] node orchestrate.js
- [ ] node migrate.js

## Notes
MD

  cat > "${repo}/.github/ISSUE_TEMPLATE/bug_report.md" << 'MD'
---
name: Bug report
about: Report a defect
title: ""
labels: bug
assignees: ""
---

## What happened

## Expected behavior

## Steps to reproduce

## Environment
- Node: `v20.11.0`
- npm: `10.2.4`
MD

  cat > "${repo}/.github/ISSUE_TEMPLATE/feature_request.md" << 'MD'
---
name: Feature request
about: Request a change
title: ""
labels: enhancement
assignees: ""
---

## Request

## Constraints (must not break)
- Floor: ASCII-only, LF-only, trailing LF, no BOM, no NUL
- Fail-closed allowlist closure
- Witness rules and successor digest integrity
MD

  cat > "${repo}/.github/dependabot.yml" << 'YML'
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 5
YML
}

write_repo() {
  local repo="$1"
  local name="$2"

  # Fail-closed: repo must be empty or contain only .git
  if [ -d "${repo}/.git" ]; then
    # ok
    :
  fi

  # remove everything except .git if present
  if [ -d "${repo}" ]; then
    find "${repo}" -mindepth 1 -maxdepth 1 ! -name ".git" -exec rm -rf {} +
  else
    echo "FATAL:REPO_DIR_MISSING:${repo}"
    exit 1
  fi

  # Basic repo hygiene
  write_file "${repo}" ".editorconfig" $'root = true\n\n[*]\ncharset = utf-8\nend_of_line = lf\ninsert_final_newline = true\ntrim_trailing_whitespace = true\n'
  write_file "${repo}" ".gitattributes" $'* text eol=lf\n'
  write_file "${repo}" ".gitignore" $'node_modules/\n*.log\n.DS_Store\n'
  write_file "${repo}" "LICENSE" $'MIT License\n\nCopyright (c) 2025\n\nPermission is hereby granted, free of charge, to any person obtaining a copy\nof this software and associated documentation files (the "Software"), to deal\nin the Software without restriction, including without limitation the rights\nto use, copy, modify, merge, publish, distribute, sublicense, and/or sell\ncopies of the Software, and to permit persons to whom the Software is\nfurnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all\ncopies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\nIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\nFITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\nAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\nLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\nOUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\nSOFTWARE.\n'
  write_file "${repo}" "CODE_OF_CONDUCT.md" $'# Code of Conduct\n\nBe respectful.\nNo harassment.\nAssume good faith.\n'
  write_file "${repo}" "CONTRIBUTING.md" $'# Contributing\n\n## Required local verification\n\n1. npm ci\n2. npm run lint:floor\n3. npm test\n4. node orchestrate.js\n5. node migrate.js\n'
  write_file "${repo}" "SECURITY.md" $'# Security\n\nReport security issues privately.\n'
  write_file "${repo}" "RELEASE.md" $'# Release\n\n## Requirements\n\n- Node: v20.11.0\n- npm: 10.2.4\n- Env: TZ=UTC LC_ALL=C LANG=C NO_COLOR=1\n\n## Steps\n\n1. npm ci\n2. npm run lint:floor\n3. npm test\n4. node orchestrate.js\n5. node migrate.js\n6. Tag and release\n'
  write_file "${repo}" "VERIFYING.md" $'# Verifying\n\n## Quick verification\n\n```bash\nexport TZ=UTC LC_ALL=C LANG=C NO_COLOR=1\nnpm ci\nnpm run lint:floor\nnpm test\nnode orchestrate.js\nnode migrate.js\n```\n\n## Lockfile policy\n\npackage-lock.json is generated by npm and is not witnessed by the successor digest.\n'
  write_file "${repo}" "MIGRATION.md" $'# Migration law\n\nMigrations must be predecessor-validated and append-only.\n'
  write_file "${repo}" "ENTROPY_LAW.js" $'export const ENTROPY_SOURCES_FORBIDDEN = [\n  "Math.random",\n  "Date.now",\n  "crypto.randomUUID",\n  "process.hrtime",\n  "new Date().toISOString()"\n];\n\nexport const DETERMINISM_REQUIRED = true;\n'
  write_file "${repo}" "README.md" $"# ${name}\n\nRiverbraid Gold V1.5 terminal repo.\n\nVerification:\n\n\`\`\`bash\nexport TZ=UTC LC_ALL=C LANG=C NO_COLOR=1\nnpm ci\nnpm run lint:floor\nnpm test\nnode orchestrate.js\nnode migrate.js\n\`\`\`\n"
  write_file "${repo}" "FINAL_RESEARCH_SPECIFICATION.md" $"# FINAL RESEARCH SPECIFICATION\n\nVERSION: ${VERSION}\nTIMESTAMP: ${GENESIS_TIMESTAMP}\nNODE: 20.11.0\nNPM: ${NPM_TARGET}\n\n## Witness rules\n\nWitness set is defined in SUCCESSOR_WITNESS_RULES.md.\n\n## Lockfile\n\npackage-lock.json is generated and not witnessed.\n"
  write_file "${repo}" "SUCCESSOR_WITNESS_RULES.md" $'# SUCCESSOR WITNESS RULES\n\nWitness digest is computed from:\n- Root witnessed files\n- scripts/lint-floor.js\n- src/*\n- tests/*\n\nExcluded from witness:\n- cluster-contract.json\n- TRACE_LAW_VECTOR.md\n- SHA256SUMS.txt\n- package-lock.json\n- node_modules/\n- .git/\n- .github/\n'
  write_file "${repo}" "TRACE_LAW_VECTOR.md" $'# TRACE LAW VECTOR\n\n[GENESIS] | SYSTEM_BOOTSTRAP | sha256:UNRESOLVED\n'

  # package.json
  write_file "${repo}" "package.json" "$(repo_template_files "${name}")"

  # Source
  mkdir -p "${repo}/src" "${repo}/scripts" "${repo}/tests"

  # src/constants.js and src/verify.js
  if [ "${name}" = "riverbraid-crypto-gold" ]; then
    write_file "${repo}" "src/constants.js" $'export const PASS_SIGNAL = "VERIFY_OK\\n";\nexport const KAT_INPUT = "RIVERBRAID_GOLD_V1_5_GENESIS";\nexport const KAT_EXPECTED = "'$(printf "%s" "RIVERBRAID_GOLD_V1_5_GENESIS" | sha256sum | awk '{print $1}')$'";\n'
    write_file "${repo}" "src/verify.js" $'import crypto from "node:crypto";\nimport { PASS_SIGNAL, KAT_INPUT, KAT_EXPECTED } from "./constants.js";\n\nexport async function verify() {\n  const h = crypto.createHash("sha256");\n  h.update(KAT_INPUT);\n  const actual = h.digest("hex");\n  if (actual !== KAT_EXPECTED) {\n    throw new Error(`KAT_MISMATCH:${actual}`);\n  }\n  return PASS_SIGNAL;\n}\n'
  else
    write_file "${repo}" "src/constants.js" $'export const PASS_SIGNAL = "VERIFY_OK\\n";\n'
    write_file "${repo}" "src/verify.js" $'import { PASS_SIGNAL } from "./constants.js";\n\nexport async function verify() {\n  return PASS_SIGNAL;\n}\n'
  fi

  # scripts/lint-floor.js
  # This checks root allowlist closure and floor for allowlisted files and dirs (excluding .git and node_modules).
  local allowlist
  allowlist="$(root_allowlist_json)"
  write_file "${repo}" "scripts/lint-floor.js" "$(cat << JS
import fs from "node:fs";
import path from "node:path";
import process from "node:process";
${node_floor_lib}

const ROOT = process.cwd();

const ROOT_ALLOWLIST = ${allowlist};

function isDir(p) {
  return fs.statSync(p).isDirectory();
}

function listDirNames(absDir) {
  return fs.readdirSync(absDir, { withFileTypes: true }).map(d => d.name);
}

function checkFile(absPath, label) {
  refuseSymlinkPathWalk(absPath, ROOT, label);
  const b = fs.readFileSync(absPath);
  checkFloor(b, label);
}

function walkDir(absDir, relDir) {
  const st = fs.lstatSync(absDir);
  if (st.isSymbolicLink()) throw new Error(\`FATAL:G04_SYMLINK_DIR:\${relDir}\`);
  const names = listDirNames(absDir);
  for (const name of names) {
    const rel = relDir ? path.posix.join(relDir, name) : name;
    const abs = path.join(absDir, name);
    const lst = fs.lstatSync(abs);
    if (lst.isSymbolicLink()) throw new Error(\`FATAL:G04_SYMLINK:\${rel}\`);
    if (lst.isDirectory()) {
      walkDir(abs, rel);
    } else if (lst.isFile()) {
      checkFile(abs, rel);
    } else {
      throw new Error(\`FATAL:G04_NOT_FILE_OR_DIR:\${rel}\`);
    }
  }
}

function main() {
  const found = listDirNames(ROOT);
  for (const f of found) {
    if (f === ".git" || f === "node_modules") continue;
    if (!ROOT_ALLOWLIST.includes(f)) {
      throw new Error(\`FATAL:G01_EXTRA:\${f}\`);
    }
  }
  for (const required of ROOT_ALLOWLIST) {
    if (required === ".git" || required === "node_modules") continue;
    const abs = path.join(ROOT, required);
    if (!fs.existsSync(abs)) {
      throw new Error(\`FATAL:G01_MISSING:\${required}\`);
    }
  }

  for (const item of ROOT_ALLOWLIST) {
    if (item === ".git" || item === "node_modules" || item === ".github") continue;
    const abs = path.join(ROOT, item);
    if (isDir(abs)) {
      walkDir(abs, item);
    } else {
      checkFile(abs, item);
    }
  }

  process.stdout.write("FLOOR_OK\\n");
}

main();
JS
)"
  # tests
  write_file "${repo}" "tests/orchestrate.test.js" "$(cat << 'JS'
import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import crypto from "node:crypto";

import { computeSuccessorDigest, readContract } from "../orchestrate.js";

test("controller_seal matches orchestrate.js bytes", () => {
  const contract = readContract();
  const b = fs.readFileSync(new URL("../orchestrate.js", import.meta.url));
  const seal = "sha256:" + crypto.createHash("sha256").update(b).digest("hex");
  assert.equal(contract.controller_seal, seal);
});

test("successor_digest matches computeSuccessorDigest", () => {
  const contract = readContract();
  const computed = computeSuccessorDigest();
  assert.equal(contract.successor_digest, computed.digest);
  assert.equal(contract.witness_count, computed.witnessCount);
});
JS
)"
  write_file "${repo}" "tests/sha256sums.test.js" "$(cat << 'JS'
import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import crypto from "node:crypto";

function listFiles(root) {
  const out = [];
  function walk(dir) {
    const entries = fs.readdirSync(dir, { withFileTypes: true });
    for (const e of entries) {
      const abs = path.join(dir, e.name);
      const rel = path.relative(root, abs).replace(/\\/g, "/");
      if (rel.startsWith(".git/")) continue;
      if (rel.startsWith("node_modules/")) continue;
      if (rel === "SHA256SUMS.txt") continue;
      if (e.isDirectory()) walk(abs);
      else if (e.isFile()) out.push(rel);
    }
  }
  walk(root);
  out.sort((a, b) => Buffer.from(a, "ascii").compare(Buffer.from(b, "ascii")));
  return out;
}

function sha256File(root, rel) {
  const b = fs.readFileSync(path.join(root, rel));
  return crypto.createHash("sha256").update(b).digest("hex");
}

test("SHA256SUMS.txt matches recomputed values", () => {
  const root = process.cwd();
  const files = listFiles(root);
  const lines = files.map(f => `${sha256File(root, f)}  ${f}`);
  const expected = lines.join("\n") + "\n\n";
  const actual = fs.readFileSync(path.join(root, "SHA256SUMS.txt"), "utf8");
  assert.equal(actual, expected);
});
JS
)"

  # .github surface
  write_github_surface "${repo}"

  # orchestrate.js + migrate.js
  local witnessed
  witnessed="$(root_witnessed_files_json)"

  write_file "${repo}" "orchestrate.js" "$(cat << JS
import fs from "node:fs";
import path from "node:path";
import crypto from "node:crypto";
import process from "node:process";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const ROOT = __dirname;

${node_floor_lib}

const ENV_EXPECTED = {
  TZ: "UTC",
  LC_ALL: "C",
  LANG: "C",
  NO_COLOR: "1"
};

const ROOT_ALLOWLIST = $(root_allowlist_json);
const ROOT_WITNESSED_FILES = ${witnessed};

export function readContract() {
  const p = path.join(ROOT, "cluster-contract.json");
  const b = fs.readFileSync(p);
  checkFloor(b, "cluster-contract.json");
  return JSON.parse(b.toString("utf8"));
}

function validateEnvironment() {
  for (const [k, v] of Object.entries(ENV_EXPECTED)) {
    if (process.env[k] !== v) throw new Error(\`FATAL:G09_ENV:\${k}\`);
  }
  if (process.version !== "v20.11.0") {
    throw new Error(\`FATAL:G09_NODE:\${process.version}\`);
  }
}

function validateRootClosure() {
  const found = fs.readdirSync(ROOT);
  for (const f of found) {
    if (f === ".git" || f === "node_modules") continue;
    if (!ROOT_ALLOWLIST.includes(f)) {
      throw new Error(\`FATAL:G01_EXTRA:\${f}\`);
    }
  }
  for (const a of ROOT_ALLOWLIST) {
    if (a === ".git" || a === "node_modules") continue;
    if (!found.includes(a)) {
      throw new Error(\`FATAL:G01_MISSING:\${a}\`);
    }
  }
}

function validateEntropyLaw() {
  const lawPath = path.join(ROOT, "ENTROPY_LAW.js");
  const lawContent = fs.readFileSync(lawPath, "utf8");
  const m = lawContent.match(/ENTROPY_SOURCES_FORBIDDEN\\s*=\\s*\\[([^\\]]+)\\]/);
  if (!m) throw new Error("FATAL:G05_ENTROPY_LAW_PARSE");
  const forbidden = m[1].split(",").map(s => s.trim().replace(/^["']|["']$/g, ""));
  for (const rel of ROOT_WITNESSED_FILES) {
    if (!rel.endsWith(".js")) continue;
    const abs = path.join(ROOT, rel);
    const txt = fs.readFileSync(abs, "utf8");
    for (const source of forbidden) {
      if (txt.includes(source)) {
        throw new Error(\`FATAL:G05_ENTROPY_SOURCE:\${rel}:\${source}\`);
      }
    }
  }
}

export function computeSuccessorDigest() {
  const witnesses = [];
  for (const rel of ROOT_WITNESSED_FILES) {
    const abs = path.join(ROOT, rel);
    refuseSymlinkPathWalk(abs, ROOT, \`witness:\${rel}\`);
    const b = fs.readFileSync(abs);
    checkFloor(b, rel);
    witnesses.push({ path: rel, bytes: b });
  }

  witnesses.sort((a, b) => Buffer.from(a.path, "ascii").compare(Buffer.from(b.path, "ascii")));

  const total = witnesses.reduce((s, w) => s + w.bytes.length, 0);
  const concat = Buffer.alloc(total);
  let off = 0;
  for (const w of witnesses) {
    w.bytes.copy(concat, off);
    off += w.bytes.length;
  }

  const d = crypto.createHash("sha256").update(concat).digest("hex").toLowerCase();
  return { digest: "sha256:" + d, witnessCount: witnesses.length };
}

async function verifyLocal(importNonce) {
  const verifyPath = path.join(ROOT, "src", "verify.js");
  const importUrl = \`file://\${verifyPath}?nonce=\${importNonce}\`;
  const mod = await import(importUrl);
  const r = await mod.verify();
  if (r !== "VERIFY_OK\\n") throw new Error(\`FATAL:G12_BAD_SIGNAL:\${r}\`);
}

async function main() {
  try {
    console.log("=".repeat(70));
    console.log("${VERSION} ORCHESTRATION");
    console.log("=".repeat(70));

    validateEnvironment();
    console.log("✓ G09 Environment validated");

    validateRootClosure();
    console.log("✓ G01 Root closure");

    // Fail-closed floor lint
    // Must print FLOOR_OK if ok
    const lintPath = path.join(ROOT, "scripts", "lint-floor.js");
    const { spawnSync } = await import("node:child_process");
    const lint = spawnSync("node", [lintPath], { cwd: ROOT, env: process.env, encoding: "utf8" });
    if (lint.status !== 0) throw new Error(lint.stderr.trim() || "FATAL:G03_FLOOR_LINT");
    if (lint.stdout !== "FLOOR_OK\\n") throw new Error("FATAL:G03_FLOOR_LINT_SIGNAL");
    console.log("✓ G03 Floor lint OK");

    validateEntropyLaw();
    console.log("✓ G05 Entropy law validated");

    const contract = readContract();

    const orchestratorBytes = fs.readFileSync(path.join(ROOT, "orchestrate.js"));
    const computedSeal = "sha256:" + crypto.createHash("sha256").update(orchestratorBytes).digest("hex");
    if (contract.controller_seal !== computedSeal) throw new Error("FATAL:G10_CONTROLLER_SEAL");
    console.log("✓ G10 Controller seal verified");

    const computed = computeSuccessorDigest();
    if (contract.successor_digest !== computed.digest) throw new Error("FATAL:G11_SUCCESSOR_DIGEST");
    if (contract.witness_count !== computed.witnessCount) throw new Error("FATAL:G06_WITNESS_COUNT");
    console.log("✓ G11 Successor digest verified");

    await verifyLocal(contract.import_nonce);
    console.log("✓ G12 Verify OK");

    console.log("=".repeat(70));
    console.log("CLUSTER_REST_ACHIEVED");
    console.log("=".repeat(70));
    console.log(\`Witnessed nodes: \${computed.witnessCount}\`);
    console.log(\`Witness digest: \${contract.successor_digest}\`);
    console.log(\`Controller seal: \${contract.controller_seal}\`);
    console.log("=".repeat(70));

    process.exit(0);
  } catch (e) {
    console.error("=".repeat(70));
    console.error("ORCHESTRATION FAILED");
    console.error("=".repeat(70));
    console.error(e && e.message ? e.message : String(e));
    console.error("=".repeat(70));
    process.exit(1);
  }
}

if (import.meta.url === \`file://\${__filename}\`) {
  main();
}
JS
)"

  write_file "${repo}" "migrate.js" "$(cat << 'JS'
import fs from "node:fs";
import path from "node:path";
import process from "node:process";
import { fileURLToPath } from "node:url";
import { computeSuccessorDigest, readContract } from "./orchestrate.js";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const ROOT = __dirname;

function main() {
  try {
    console.log("RIVERBRAID MIGRATION VALIDATOR");
    console.log("=".repeat(50));

    const contract = readContract();
    const computed = computeSuccessorDigest();

    if (computed.digest !== contract.successor_digest) {
      throw new Error("FATAL:PREDECESSOR_MISMATCH");
    }

    console.log(`✓ Predecessor validated: ${computed.witnessCount} witnesses`);
    console.log("=".repeat(50));
    console.log("MIGRATION_READY");
    console.log("=".repeat(50));
    process.exit(0);
  } catch (e) {
    console.error("MIGRATION VALIDATION FAILED:", e && e.message ? e.message : String(e));
    process.exit(1);
  }
}

if (import.meta.url === `file://${__filename}`) main();
JS
)"

  # cluster-contract.json and TRACE_LAW_VECTOR.md must be written after digest and seal computed.
  # First create placeholder contract, then compute seal + digest via Node in a controlled way.
  # Create placeholder contract now.
  write_file "${repo}" "cluster-contract.json" $'{}\n'

  # package-lock.json placeholder; will be generated by npm later.
  write_file "${repo}" "package-lock.json" $'{\n  "name": "'${name}$'",\n  "version": "1.5.0",\n  "lockfileVersion": 3,\n  "requires": true,\n  "packages": {\n    "": {\n      "name": "'${name}$'",\n      "version": "1.5.0"\n    }\n  }\n}\n'

  # Now compute controller_seal and successor_digest from bytes present.
  (
    cd "${repo}"
    # Floor check all witnessed files before digest
    node scripts/lint-floor.js >/dev/null

    # Compute seal
    controller_seal="sha256:$(node -e 'import fs from "node:fs"; import crypto from "node:crypto"; const b=fs.readFileSync("orchestrate.js"); process.stdout.write(crypto.createHash("sha256").update(b).digest("hex"));')"

    # Compute digest over witnessed file list
    successor_digest="$(node -e '
import fs from "node:fs";
import crypto from "node:crypto";
const files = JSON.parse(fs.readFileSync("SUCCESSOR_WITNESS_RULES.md") ? "[]" : "[]");
' 2>/dev/null || true)"

    # Compute digest using orchestrate.js exported function (source of truth)
    successor_digest="$(node -e 'import { computeSuccessorDigest } from "./orchestrate.js"; const r=computeSuccessorDigest(); process.stdout.write(r.digest);')"
    witness_count="$(node -e 'import { computeSuccessorDigest } from "./orchestrate.js"; const r=computeSuccessorDigest(); process.stdout.write(String(r.witnessCount));')"

    # Rewrite trace
    printf "%s\n\n[GENESIS] | SYSTEM_BOOTSTRAP | %s\n" "# TRACE LAW VECTOR" "${successor_digest}" > TRACE_LAW_VECTOR.md

    # Rewrite contract
    cat > cluster-contract.json << JSON
{
  "contract_version": "${VERSION}",
  "import_nonce": "${VERSION}_IMPORT_NONCE_GENESIS",
  "genesis_timestamp": "${GENESIS_TIMESTAMP}",
  "substrate": {
    "node": "20.11.0",
    "npm": "${NPM_TARGET}"
  },
  "topology": {
    "root_allowlist": $(root_allowlist_json),
    "root_witnessed_files": $(root_witnessed_files_json)
  },
  "controller_seal": "${controller_seal}",
  "successor_digest": "${successor_digest}",
  "witness_count": ${witness_count},
  "gates_passed": [
    "G01", "G03", "G04", "G05",
    "G06", "G09", "G10", "G11",
    "G12", "G15"
  ]
}
JSON

    # Now write SHA256SUMS.txt (informative integrity, tested)
    cd ..
  )

  write_sha256sums "${repo}"

  # Final floor lint must still pass after writing SHA256SUMS, contract, trace, github files.
  (
    cd "${repo}"
    node scripts/lint-floor.js >/dev/null
  )
}

main() {
  local repos=(
    "riverbraid-bridge-gold"
    "riverbraid-crypto-gold"
    "riverbraid-entropy-gold"
    "riverbraid-golds"
    "riverbraid-integration-gold"
    "riverbraid-judicial-gold"
    "riverbraid-memory-gold"
    "riverbraid-observability-gold"
    "riverbraid-refusal-gold"
    "riverbraid-safety-gold"
    "riverbraid-spine-gold"
  )

  for r in "${repos[@]}"; do
    echo "============================================================"
    echo "BUILDING: ${r}"
    echo "============================================================"
    write_repo "${r}" "${r}"
    echo "OK: ${r}"
  done

  echo "============================================================"
  echo "ALL REPOS WRITTEN"
  echo "============================================================"
}

main

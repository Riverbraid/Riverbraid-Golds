#!/usr/bin/env node
"use strict";
const fs = require("fs");
const path = require("path");
const { execSync } = require("child_process");
const root = path.resolve("..");
const repos = fs.readdirSync(root).filter(f => fs.statSync(path.join(root, f)).isDirectory() && f.startsWith("Riverbraid"));

let failures = 0;
for (const repo of repos) {
    const repoPath = path.join(root, repo);
    const rolePath = path.join(repoPath, "repo.role.json");
    let status = "active";
    
    if (fs.existsSync(rolePath)) {
        status = JSON.parse(fs.readFileSync(rolePath, "utf8")).status;
    }

    try {
        console.log(`Auditing ${repo} [${status}]...`);
        execSync("npm test", { cwd: repoPath, stdio: "ignore" });
        console.log(`[PASS] ${repo}`);
    } catch (e) {
        console.error(`[FAIL] ${repo}`);
        failures++;
    }
}
if (failures > 0) { console.error(`Audit failed with ${failures} errors.`); process.exit(1); }
console.log("CONSTELLATION AUDIT PASSED.");